class_name SpriteCoord
extends Node2D


const INDICATOR_AXES: Dictionary = {
    SubTag.INDICATOR_TOP: &"x",
    SubTag.INDICATOR_BOTTOM: &"x",
    SubTag.INDICATOR_LEFT: &"y",
}


var _indicators: Dictionary = {}


func move_sprite(sprite: Sprite2D, coord: Vector2i) -> void:
    sprite.position = ConvertCoord.get_position(coord)
    if sprite.is_in_group(SubTag.PC):
        move_indicator(coord, _indicators)


func move_indicator(coord: Vector2i, indicators: Dictionary) -> void:
    var sprite: Sprite2D
    var axis: StringName

    for i: StringName in INDICATOR_AXES:
        if not indicators.has(i):
            continue
        sprite = indicators[i]
        axis = INDICATOR_AXES[i]
        sprite.position[axis] = ConvertCoord.get_position(coord)[axis]


func _on_SpriteFactory_sprite_created(sprites: Array) -> void:
    for i: TaggedSprite in sprites:
        if i.main_tag == MainTag.INDICATOR:
            _indicators[i.sub_tag] = i.sprite
