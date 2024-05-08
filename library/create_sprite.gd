class_name CreateSprite


static func create(main_tag: StringName, sub_tag: StringName, coord: Vector2i,
        offset: Vector2i = Vector2i(0, 0)) -> TaggedSprite:
    var packed_sprite: PackedScene = SpriteScene.get_sprite_scene(sub_tag)
    var new_sprite: Sprite2D
    var palette: Dictionary = TransferData.palette

    if packed_sprite == null:
        return null
    new_sprite = packed_sprite.instantiate()

    new_sprite.add_to_group(main_tag)
    new_sprite.add_to_group(sub_tag)
    new_sprite.position = ConvertCoord.get_position(coord, offset)
    new_sprite.modulate = Palette.get_color(palette, main_tag, true)
    new_sprite.z_index = ZLayer.get_z_layer(main_tag)

    return TaggedSprite.new(new_sprite, main_tag, sub_tag)
