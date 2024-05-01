class_name ActorAction
extends Node2D


var _pc: Sprite2D
var _actor_states: Dictionary = {}


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
    print("hit")


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
