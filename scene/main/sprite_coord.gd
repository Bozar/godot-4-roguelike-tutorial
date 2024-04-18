class_name SpriteCoord
extends Node2D


const INDICATOR_AXES: Dictionary = {
    SubTag.INDICATOR_TOP: &"x",
    SubTag.INDICATOR_BOTTOM: &"x",
    SubTag.INDICATOR_LEFT: &"y",
}

const HASHED_MAIN_TAGS: Dictionary = {
    MainTag.GROUND: 1,
    MainTag.BUILDING: 2,
    MainTag.TRAP: 3,
    MainTag.ACTOR: 4,
}

const INVALID_HASH_VALUE: int = -1


# {hashed_coord: {hashed_sprite: sprite}}
var _dungeon_sprites: Dictionary = {}
var _indicators: Dictionary = {}


func move_sprite(sprite: Sprite2D, coord: Vector2i, z_layer: int) -> void:
    var main_tag: StringName = SpriteState.get_main_tag(sprite)

    _remove_sprite(sprite, main_tag)
    sprite.position = ConvertCoord.get_position(coord)
    sprite.z_index = z_layer
    _add_sprite(sprite, main_tag)

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


func get_sprites_by_coord(coord: Vector2i) -> Array:
    var hashed_coord: int = _hash_coord(coord)
    var sprites: Dictionary = _dungeon_sprites.get(hashed_coord, {})

    if sprites.is_empty():
        return []
    return sprites.values().filter(SpriteState.is_valid_sprite)


func get_sprite_by_coord(main_tag: StringName, coord: Vector2i, z_layer: int) \
        -> Sprite2D:
    for i: Sprite2D in get_sprites_by_coord(coord):
        if i.is_in_group(main_tag) and (i.z_index == z_layer):
            return i
    return null


func _on_SpriteFactory_sprite_created(tagged_sprites: Array) -> void:
    for i: TaggedSprite in tagged_sprites:
        if i.main_tag == MainTag.INDICATOR:
            _indicators[i.sub_tag] = i.sprite
        else:
            _add_sprite(i.sprite, i.main_tag)


func _on_SpriteFactory_sprite_removed(sprites: Array) -> void:
    for i: Sprite2D in sprites:
        _remove_sprite(i, SpriteState.get_main_tag(i))


# YY-XX: coord.y - coord.x
func _hash_coord(coord: Vector2i) -> int:
    if not DungeonSize.is_in_dungeon(coord):
        push_error("Invalid coord: %d, %d" % [coord.x, coord.y])
        return INVALID_HASH_VALUE
    return floor(coord.x + coord.y * pow(10, 2))


# M-ZZ: hashed_main_tag - z_layer
func _hash_sprite(main_tag: StringName, z_layer: int) -> int:
    if not HASHED_MAIN_TAGS.has(main_tag):
        push_error("Invalid main_tag: %s" % main_tag)
        return INVALID_HASH_VALUE
    elif not ZLayer.is_valid_z_layer(z_layer):
        push_error("Invalid z_layer: %d" % z_layer)
        return INVALID_HASH_VALUE

    var hashed_main_tag: int = HASHED_MAIN_TAGS[main_tag]
    return floor(z_layer + hashed_main_tag * pow(10, 2))


func _add_sprite(sprite: Sprite2D, main_tag: StringName) -> void:
    var coord: Vector2i = ConvertCoord.get_coord(sprite)
    var z_layer: int = sprite.z_index
    var hashed_coord: int = _hash_coord(coord)
    var hashed_sprite: int = _hash_sprite(main_tag, z_layer)
    var sprites: Dictionary

    if _dungeon_sprites.has(hashed_coord):
        sprites = _dungeon_sprites[hashed_coord]
        if sprites.has(hashed_sprite):
            push_error("Hash collide: %d-%d, %s -> %s." % [
                    hashed_coord, hashed_sprite,
                    sprite.name, sprites[hashed_sprite].name
                    ])
            return
    else:
        _dungeon_sprites[hashed_coord] = {}
    _dungeon_sprites[hashed_coord][hashed_sprite] = sprite
    _set_visibility(coord)


func _remove_sprite(sprite: Sprite2D, main_tag: StringName) -> void:
    var coord: Vector2i = ConvertCoord.get_coord(sprite)
    var z_layer: int = sprite.z_index
    var hashed_coord: int = _hash_coord(coord)
    var hashed_sprite: int = _hash_sprite(main_tag, z_layer)
    var sprites: Dictionary = _dungeon_sprites.get(hashed_coord, {})

    if not sprites.erase(hashed_sprite):
        push_warning("Sprite not hashed: %d-%d, %s." %
                [hashed_coord, hashed_sprite, sprite.name])
    _set_visibility(coord)


func _set_visibility(coord: Vector2i) -> void:
    var sprites: Array = get_sprites_by_coord(coord)
    var last_sprite: Sprite2D

    sprites.sort_custom(_sort_by_layer)
    last_sprite = sprites.pop_back()
    for i: Sprite2D in sprites:
        VisualEffect.set_visibility(i, false)
    if last_sprite != null:
        VisualEffect.set_visibility(last_sprite, true)


func _sort_by_layer(this_sprite: Sprite2D, that_sprite: Sprite2D) -> bool:
    return this_sprite.z_index < that_sprite.z_index
