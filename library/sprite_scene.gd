class_name SpriteScene


const SPRITE_SCENES: Dictionary = {
    # Actor
    SubTag.PC: preload("res://sprite/pc.tscn"),
}


static func get_sprite_scene(sub_tag: StringName) -> PackedScene:
    if SPRITE_SCENES.has(sub_tag):
        return SPRITE_SCENES[sub_tag]
    push_error("Invalid sub tag: %s" % sub_tag)
    return null
