# class_name SpriteFactory
extends Node2D


signal sprite_created(tagged_sprites: Array)
signal sprite_removed(sprites: Array)


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
