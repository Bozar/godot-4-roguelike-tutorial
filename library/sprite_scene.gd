class_name SpriteScene


const SPRITE_SCENES: Dictionary = {
    # Ground
    SubTag.DUNGEON_FLOOR: preload("res://sprite/dungeon_floor.tscn"),

    # Trap
    SubTag.BULLET: preload("res://sprite/bullet.tscn"),

    # Building
    SubTag.WALL: preload("res://sprite/wall.tscn"),

    # Actor
    SubTag.PC: preload("res://sprite/pc.tscn"),
    SubTag.HOUND: preload("res://sprite/hound.tscn"),

    # Indicator
    SubTag.INDICATOR_TOP: preload("res://sprite/indicator_top.tscn"),
    SubTag.INDICATOR_BOTTOM: preload("res://sprite/indicator_bottom.tscn"),
    SubTag.INDICATOR_LEFT: preload("res://sprite/indicator_left.tscn"),
}


static func get_sprite_scene(sub_tag: StringName) -> PackedScene:
    if SPRITE_SCENES.has(sub_tag):
        return SPRITE_SCENES[sub_tag]
    push_error("Invalid sub tag: %s" % sub_tag)
    return null
