# class_name SpriteState
extends Node2D


var _ref_SpriteCoord: SpriteCoord
var _ref_SpriteTag: SpriteTag


func move_sprite(sprite: Sprite2D, coord: Vector2i) -> void:
    _ref_SpriteCoord.move_sprite(sprite, coord)


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
