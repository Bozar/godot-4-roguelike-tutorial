# class_name SpriteState
extends Node2D


var _ref_SpriteCoord: SpriteCoord
var _ref_SpriteTag: SpriteTag


func is_valid_sprite(sprite: Sprite2D) -> bool:
    return not sprite.is_queued_for_deletion()


func move_sprite(sprite: Sprite2D, coord: Vector2i,
        z_layer: int = sprite.z_index) -> void:
    _ref_SpriteCoord.move_sprite(sprite, coord, z_layer)


func get_sprites_by_coord(coord: Vector2i) -> Array:
    return _ref_SpriteCoord.get_sprites_by_coord(coord)


func get_sprite_by_coord(main_tag: StringName, coord: Vector2i,
        z_layer: int = ZLayer.get_z_layer(main_tag)) -> Sprite2D:
    return _ref_SpriteCoord.get_sprite_by_coord(main_tag, coord, z_layer)


func get_main_tag(sprite: Sprite2D) -> StringName:
    return _ref_SpriteTag.get_main_tag(sprite)


func get_sub_tag(sprite: Sprite2D) -> StringName:
    return _ref_SpriteTag.get_sub_tag(sprite)


func get_sprites_by_tag(main_tag: StringName, sub_tag: StringName) -> Array:
    return _ref_SpriteTag.get_sprites_by_tag(main_tag, sub_tag)


func get_sprites_by_main_tag(main_tag: StringName) -> Array:
    return _ref_SpriteTag.get_sprites_by_tag(main_tag, "")


func get_sprites_by_sub_tag(sub_tag: StringName) -> Array:
    return _ref_SpriteTag.get_sprites_by_tag("", sub_tag)
