class_name TaggedSprite


var sprite: Sprite2D:
    get:
        return _sprite
var main_tag: StringName:
    get:
        return _main_tag
var sub_tag: StringName:
    get:
        return _sub_tag


var _sprite: Sprite2D
var _main_tag: StringName
var _sub_tag: StringName


func _init(sprite_: Sprite2D, main_tag_: StringName, sub_tag_: StringName) \
        -> void:
    _sprite = sprite_
    _main_tag = main_tag_
    _sub_tag = sub_tag_
