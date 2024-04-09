# class_name SpriteState
extends Node2D


var _ref_SpriteCoord: SpriteCoord


func move_sprite(sprite: Sprite2D, coord: Vector2i) -> void:
    _ref_SpriteCoord.move_sprite(sprite, coord)
