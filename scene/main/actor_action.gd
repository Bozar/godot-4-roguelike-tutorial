class_name ActorAction
extends Node2D


var _ref_RandomNumber: RandomNumber
var _ref_PcAction: PcAction
var _ref_GameProgress: GameProgress


var _pc: Sprite2D
var _actor_states: Dictionary = {}
var _map_2d: Dictionary = Map2D.init_map(DijkstraPathfinding.UNKNOWN)


func hit_actor(sprite: Sprite2D) -> void:
    var actor_state: ActorState = _get_actor_state(sprite)

    if actor_state == null:
        return
    actor_state.hit_damage = GameData.HIT_DAMAGE
    VisualEffect.switch_sprite(sprite, VisualTag.PASSIVE)


func _on_Schedule_turn_started(sprite: Sprite2D) -> void:
    var actor_state: ActorState = _get_actor_state(sprite)
    var actor_coord: Vector2i = ConvertCoord.get_coord(sprite)
    var pc_coord: Vector2i = ConvertCoord.get_coord(_pc)
    var distanct_to_pc: int

    if actor_state == null:
        return

    if actor_state.hit_damage == 1:
        VisualEffect.switch_sprite(sprite, VisualTag.DEFAULT)
    actor_state.hit_damage -= 1
    if actor_state.hit_damage > 0:
        ScheduleHelper.start_next_turn()
        return

    distanct_to_pc = ConvertCoord.get_range(actor_coord, pc_coord)
    if distanct_to_pc == 1:
        _hit_pc()
    elif distanct_to_pc <= GameData.NPC_SIGHT_RANGE:
        _approach_pc(_map_2d, sprite, [pc_coord])
    elif _ref_PcAction.alert_duration > 0:
        _approach_pc(_map_2d, sprite, [_ref_PcAction.alert_coord])

    ScheduleHelper.start_next_turn()


func _on_SpriteFactory_sprite_created(tagged_sprites: Array) -> void:
    var id: int

    for i: TaggedSprite in tagged_sprites:
        if not i.main_tag == MainTag.ACTOR:
            continue
        if i.sub_tag == SubTag.PC:
            _pc = i.sprite
        else:
            id = i.sprite.get_instance_id()
            _actor_states[id] = ActorState.new()


func _on_SpriteFactory_sprite_removed(sprites: Array) -> void:
    var id: int

    for i: Sprite2D in sprites:
        if not _is_npc(i):
            continue
        id = i.get_instance_id()
        if not _actor_states.erase(id):
            push_error("Actor not found: %s." % [i.name])


func _hit_pc() -> void:
    _ref_GameProgress.game_over.emit(false)


func _get_actor_state(sprite: Sprite2D) -> ActorState:
    if not _is_npc(sprite):
        return

    var id: int = sprite.get_instance_id()

    if _actor_states.has(id):
        return _actor_states[id]
    push_error("Actor not found: %s." % [sprite.name])
    return null


func _is_npc(sprite: Sprite2D) -> bool:
    return sprite.is_in_group(MainTag.ACTOR) and \
            (not sprite.is_in_group(SubTag.PC))


func _approach_pc(map_2d: Dictionary, sprite: Sprite2D, end_point: Array) \
        -> void:
    var npc_coord: Vector2i = ConvertCoord.get_coord(sprite)
    var target_coords: Array
    var move_to: Vector2i
    var trap: Sprite2D

    DijkstraPathfinding.set_obstacle_map(map_2d, _is_obstacle, [])
    DijkstraPathfinding.set_destination(map_2d, end_point)
    DijkstraPathfinding.set_distance_map(map_2d, end_point)

    target_coords = DijkstraPathfinding.get_coords(map_2d, npc_coord, 1)
    if target_coords.is_empty():
        return

    if target_coords.size() > 1:
        ArrayHelper.shuffle(target_coords, _ref_RandomNumber)
    move_to = target_coords[0]
    SpriteState.move_sprite(sprite, move_to)

    trap = SpriteState.get_trap_by_coord(move_to)
    if trap != null:
        SpriteFactory.remove_sprite(trap)


func _is_obstacle(coord: Vector2i, _opt_args: Array) -> bool:
    return SpriteState.has_building_at_coord(coord) or \
            SpriteState.has_actor_at_coord(coord)
