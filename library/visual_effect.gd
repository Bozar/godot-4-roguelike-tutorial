class_name VisualEffect


static func switch_sprite(sprite: Sprite2D, visual_tag: StringName) -> void:
    var has_switched: bool = false

    for i: Sprite2D in sprite.get_children():
        if i.name == visual_tag:
            i.visible = true
            has_switched = true
        else:
            i.visible = false
    if not has_switched:
        push_error("Invalid visual tag: %s, %s." % [sprite, visual_tag])
