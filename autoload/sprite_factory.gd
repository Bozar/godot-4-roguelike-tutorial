# class_name SpriteFactory
extends Node2D


signal sprite_created(tagged_sprites: Array)
signal sprite_removed(sprites: Array)


func clear_data() -> void:
    var dict_key: String = "callable"

    for i: Dictionary in sprite_created.get_connections():
        if sprite_created.is_connected(i[dict_key]):
            sprite_created.disconnect(i[dict_key])
    for i: Dictionary in sprite_removed.get_connections():
        if sprite_created.is_connected(i[dict_key]):
            sprite_created.disconnect(i[dict_key])


func create_sprite(main_tag: StringName, sub_tag: StringName, coord: Vector2i,
        send_signal: bool) -> TaggedSprite:
    var tagged_sprite: TaggedSprite = CreateSprite.create(main_tag, sub_tag,
            coord)
    if send_signal:
        sprite_created.emit([tagged_sprite])
    return tagged_sprite


func create_ground(sub_tag: StringName, coord: Vector2i, send_signal: bool) \
        -> TaggedSprite:
    return create_sprite(MainTag.GROUND, sub_tag, coord, send_signal)


func create_trap(sub_tag: StringName, coord: Vector2i, send_signal: bool) \
        -> TaggedSprite:
    return create_sprite(MainTag.TRAP, sub_tag, coord, send_signal)


func create_building(sub_tag: StringName, coord: Vector2i, send_signal: bool) \
        -> TaggedSprite:
    return create_sprite(MainTag.BUILDING, sub_tag, coord, send_signal)


func create_actor(sub_tag: StringName, coord: Vector2i, send_signal: bool) \
        -> TaggedSprite:
    return create_sprite(MainTag.ACTOR, sub_tag, coord, send_signal)


func remove_sprite(sprite: Sprite2D) -> void:
    sprite_removed.emit([sprite])
