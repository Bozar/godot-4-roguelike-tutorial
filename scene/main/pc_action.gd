class_name PcAction
extends Node2D


enum {
    NORMAL_MODE,
    AIM_MODE,
}


var ammo: int:
    get:
        return _ammo


var alert_duration: int:
    get:
        return _alert_duration


var alert_coord: Vector2i:
    get:
        return _alert_coord


var enemy_count: int:
    get:
        return _enemy_count


var progress_bar: int:
    get:
        return _progress_bar


var _ref_ActorAction: ActorAction
var _ref_GameProgress: GameProgress

@onready var _ref_PcFov: PcFov = $PcFov


var _pc: Sprite2D
var _ammo: int = GameData.MAGAZINE
var _game_mode: int = NORMAL_MODE
var _alert_duration: int = 0
var _alert_coord: Vector2i
var _enemy_count: int = GameData.MIN_ENEMY_COUNT
var _progress_bar: int = GameData.MIN_PROGRESS_BAR


func _on_SpriteFactory_sprite_created(tagged_sprites: Array) -> void:
    if _pc != null:
        return

    for i: TaggedSprite in tagged_sprites:
        if i.sub_tag == SubTag.PC:
            _pc = i.sprite
            return


func _on_Schedule_turn_started(sprite: Sprite2D) -> void:
    if not sprite.is_in_group(SubTag.PC):
        return
    _ref_GameProgress.try_spawn_npc(_pc)
    _ref_PcFov.render_fov(_pc, _game_mode)
    _alert_duration = max(0, _alert_duration - 1)
    # print("%d, %d" % [enemy_count, progress_bar])


func _on_PlayerInput_action_pressed(input_tag: StringName) -> void:
    var coord: Vector2i

    match input_tag:
        InputTag.AIM:
            _game_mode = _aim(_pc, _ammo, _game_mode)
            _ref_PcFov.render_fov(_pc, _game_mode)
            return
        InputTag.MOVE_LEFT:
            coord = Vector2i.LEFT
        InputTag.MOVE_RIGHT:
            coord = Vector2i.RIGHT
        InputTag.MOVE_UP:
            coord = Vector2i.UP
        InputTag.MOVE_DOWN:
            coord = Vector2i.DOWN
        _:
            return

    coord += ConvertCoord.get_coord(_pc)
    match _game_mode:
        AIM_MODE:
            _game_mode = _aim(_pc, _ammo, _game_mode)
            _ammo = _shoot(_pc, coord, _ammo)
            if _game_mode == NORMAL_MODE:
                _alert_hound(_pc)
                _end_turn()
            return
        NORMAL_MODE:
            if not DungeonSize.is_in_dungeon(coord):
                return
            elif SpriteState.has_building_at_coord(coord):
                return
            # If there is a trap under an actor, interact with the actor rather
            # than the trap.
            elif SpriteState.has_actor_at_coord(coord):
                _kick_back(_pc, coord)
                _end_turn()
                return
            elif SpriteState.has_trap_at_coord(coord):
                _ammo = _pick_ammo(_pc, coord, _ammo)
                # print(ammo)
                _end_turn()
                return
            _move(_pc, coord)
            _end_turn()
            return


func _on_GameProgress_game_over(player_win: bool) -> void:
    _ref_PcFov.render_fov(_pc, _game_mode)
    if not player_win:
        VisualEffect.set_dark_color(_pc)


func _pick_ammo(pc: Sprite2D, coord: Vector2i, current_ammo: int) -> int:
    SpriteFactory.remove_sprite(SpriteState.get_trap_by_coord(coord))
    SpriteState.move_sprite(pc, coord)
    return _get_valid_ammo(current_ammo + GameData.MAGAZINE)


func _get_valid_ammo(current_ammo: int) -> int:
    return max(min(current_ammo, GameData.MAX_AMMO), GameData.MIN_AMMO)


func _aim(pc: Sprite2D, current_ammo: int, current_mode: int) -> int:
    match current_mode:
        AIM_MODE:
            VisualEffect.switch_sprite(pc, VisualTag.DEFAULT)
            return NORMAL_MODE
        NORMAL_MODE:
            if current_ammo > GameData.MIN_AMMO:
                VisualEffect.switch_sprite(pc, VisualTag.ACTIVE)
                return AIM_MODE
    return NORMAL_MODE


func _shoot(pc: Sprite2D, coord: Vector2i, current_ammo: int) -> int:
    var coords: Array
    var target_coord: Vector2i
    var actor: Sprite2D

    coords = CastRay.get_coords(ConvertCoord.get_coord(pc), coord,
            _block_shoot_ray, [])
    coords = CastRay.trim_coords(coords, true, true)

    if not coords.is_empty():
        target_coord = coords.back()
        actor = SpriteState.get_actor_by_coord(target_coord)
        if actor != null:
            _kill_hound(actor, target_coord)
    return _get_valid_ammo(current_ammo - 1)


func _kick_back(pc: Sprite2D, coord: Vector2i) -> void:
    var coords: Array
    var target_coord: Vector2i
    var actor: Sprite2D = SpriteState.get_actor_by_coord(coord)
    var new_trap_coord: Vector2i

    coords = CastRay.get_coords(ConvertCoord.get_coord(pc), coord,
            _block_hit_back_ray, [])
    coords = CastRay.trim_coords(coords, true, false)
    target_coord = coords.back()

    # If the last grid is impassable, create a trap in the second last grid. The
    # hound is killed there by game design.
    if _is_impassable(target_coord):
        new_trap_coord = coords[-2]
        _kill_hound(actor, new_trap_coord)
    else:
        SpriteState.move_sprite(actor, target_coord)
        _ref_ActorAction.hit_actor(actor)


func _move(pc: Sprite2D, coord: Vector2i) -> void:
    SpriteState.move_sprite(pc, coord)


func _is_impassable(coord: Vector2i) -> bool:
    if not DungeonSize.is_in_dungeon(coord):
        return true
    elif SpriteState.has_building_at_coord(coord):
        return true
    elif SpriteState.has_actor_at_coord(coord):
        return true
    return false


func _block_shoot_ray(_source_coord: Vector2i, target_coord: Vector2i,
        _args: Array) -> bool:
    return _is_impassable(target_coord)


func _block_hit_back_ray(source_coord: Vector2i, target_coord: Vector2i,
        _args: Array) -> bool:
    var ray_length_squared: int = (source_coord - target_coord).length_squared()

    if DungeonSize.is_in_dungeon(target_coord) and \
            SpriteState.has_trap_at_coord(target_coord):
        SpriteFactory.remove_sprite(SpriteState.get_trap_by_coord(target_coord))

    if ray_length_squared == 1:
        return false
    elif ray_length_squared > (GameData.HIT_BACK ** 2):
        return true
    return _is_impassable(target_coord)


func _kill_hound(sprite: Sprite2D, coord: Vector2i) -> void:
    _add_enemy_count()
    SpriteFactory.remove_sprite(sprite)
    SpriteFactory.create_trap(SubTag.BULLET, coord, true)


func _end_turn() -> void:
    _subtract_progress_bar()
    if _enemy_count >= GameData.MAX_ENEMY_COUNT:
        _ref_GameProgress.game_over.emit(true)
    else:
        ScheduleHelper.start_next_turn()


func _alert_hound(pc: Sprite2D) -> void:
    _alert_duration = GameData.MAX_ALERT_DURATION
    _alert_coord = ConvertCoord.get_coord(pc)


func _add_enemy_count() -> void:
    _enemy_count = min(enemy_count + 1, GameData.MAX_ENEMY_COUNT)
    _progress_bar = GameData.MAX_PROGRES_BAR + 1


func _subtract_progress_bar() -> void:
    if _progress_bar > GameData.MIN_PROGRESS_BAR:
        _progress_bar -= 1
    if _progress_bar == GameData.MIN_PROGRESS_BAR:
        _enemy_count = max(enemy_count - 1, GameData.MIN_ENEMY_COUNT)
        if _enemy_count > GameData.MIN_ENEMY_COUNT:
            _progress_bar = GameData.MAX_PROGRES_BAR
