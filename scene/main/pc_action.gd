class_name PcAction
extends Node2D


enum {
    NORMAL_MODE,
    AIM_MODE,
}


var ammo: int:
    get:
        return _ammo


var _pc: Sprite2D
var _ammo: int = GameData.MAGAZINE
var _game_mode: int = NORMAL_MODE


func _on_SpriteFactory_sprite_created(sprites: Array) -> void:
    if _pc != null:
        return

    for i: TaggedSprite in sprites:
        if i.sub_tag == SubTag.PC:
            _pc = i.sprite
            return


func _on_PlayerInput_action_pressed(input_tag: StringName) -> void:
    var coord: Vector2i

    match input_tag:
        InputTag.AIM:
            _game_mode = _aim(_pc, _ammo, _game_mode)
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
            return
        NORMAL_MODE:
            if not DungeonSize.is_in_dungeon(coord):
                return
            elif SpriteState.has_building_at_coord(coord):
                return
            elif SpriteState.has_trap_at_coord(coord):
                _ammo = _pick_ammo(_pc, coord, _ammo)
                # print(ammo)
                return
            SpriteState.move_sprite(_pc, coord)


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


func _kill_hound(sprite: Sprite2D, coord: Vector2i) -> void:
    SpriteFactory.remove_sprite(sprite)
    SpriteFactory.create_trap(SubTag.BULLET, coord, true)
