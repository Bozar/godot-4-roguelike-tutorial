class_name PcFov
extends Node2D


const NO_FOV: bool = false
const MEMORY_TAGS: Array = [
    MainTag.GROUND,
    MainTag.BUILDING,
    MainTag.TRAP,
]

# 0b00: MEMORY_FLAG | SIGHT_FLAG
const DEFAULT_FOV_FLAG: int = 0b00
const IS_IN_SIGHT_FLAG: int = 0b01
const IS_IN_MEMORY_FLAG: int = 0b10


var _fov_map: Dictionary


func _ready() -> void:
    _fov_map = Map2D.init_map(DEFAULT_FOV_FLAG)


func render_fov(pc: Sprite2D) -> void:
    if NO_FOV:
        return

    var pc_coord: Vector2i = ConvertCoord.get_coord(pc)
    var this_coord: Vector2i = Vector2i(0, 0)

    DiamondFov.get_fov_map(pc_coord, _fov_map, _set_fov_value,
            GameData.PC_SIGHT_RANGE)

    for x: int in range(0, DungeonSize.MAX_X):
        for y: int in range(DungeonSize.MAX_Y):
            this_coord.x = x
            this_coord.y = y
            _set_sprite_color(this_coord, _fov_map)
            _set_sprite_visibility(this_coord, _fov_map, MEMORY_TAGS)


func _set_sprite_color(coord: Vector2i, fov_map: Dictionary) -> void:
    if _is_fov_flag(coord, fov_map, IS_IN_SIGHT_FLAG):
        for i: Sprite2D in SpriteState.get_sprites_by_coord(coord):
            VisualEffect.set_light_color(i)
    else:
        for i: Sprite2D in SpriteState.get_sprites_by_coord(coord):
            VisualEffect.set_dark_color(i)


func _set_sprite_visibility(coord: Vector2i, fov_map: Dictionary,
        memory_tags: Array) -> void:
    var sprites: Array = SpriteState.get_sprites_by_coord(coord)
    var sprite: Sprite2D

    # Only the highest sprite is visible.
    sprites.sort_custom(_sort_by_z_index)
    # If a grid is in PC's sight, remember the grid in fov_map. Show the highest
    # sprite and set its color to light.
    if _is_fov_flag(coord, fov_map, IS_IN_SIGHT_FLAG):
        _set_fov_value(coord, fov_map, IS_IN_MEMORY_FLAG, true)
        for i: Sprite2D in sprites:
            VisualEffect.set_light_color(i)
            VisualEffect.set_visibility(i, false)
        sprite = sprites.pop_back()
        if sprite != null:
            VisualEffect.set_visibility(sprite, true)
    # If a grid is out of PC's sight, hide all sprites in the grid by default.
    # If PC has seen the grid before, show the first sprite in memory_tags, and
    # set its color to dark.
    else:
        for i: Sprite2D in sprites:
            VisualEffect.set_visibility(i, false)
        if _is_fov_flag(coord, fov_map, IS_IN_MEMORY_FLAG):
            while true:
                sprite = sprites.pop_back()
                if (sprite == null) or _match_sprite_tag(sprite, memory_tags):
                    break
            if sprite != null:
                VisualEffect.set_dark_color(sprite)
                VisualEffect.set_visibility(sprite, true)


func _is_fov_flag(coord: Vector2i, fov_map: Dictionary, fov_flag: int) -> bool:
    if Map2D.is_in_map(coord, fov_map):
        # There is only one `1` in fov_flag. Return 0 (false) if the
        # correspoinding bit in fov_map[coord.x][coord.y] is 0, or a non-zero
        # integer (true).
        return fov_map[coord.x][coord.y] & fov_flag
    return false


func _set_fov_value(coord: Vector2i, fov_map: Dictionary, fov_flag: int,
        is_truthy: bool) -> void:
    if not Map2D.is_in_map(coord, fov_map):
        return

    var current_value: int = fov_map[coord.x][coord.y]

    if is_truthy:
        # Set the correspoinding bit in fov_map[coord.x][coord.y] to 1.
        # Leave other bits unchanged.
        fov_map[coord.x][coord.y] = current_value | fov_flag
    else:
        # ~fov_flag = 0b111...101...111
        # Set the correspoinding bit in fov_map[coord.x][coord.y] to 0.
        # Leave other bits unchanged.
        fov_map[coord.x][coord.y] = current_value & ~fov_flag


func _match_sprite_tag(sprite: Sprite2D, sprite_tags: Array) -> bool:
    for i: StringName in sprite_tags:
        if sprite.is_in_group(i):
            return true
    return false


func _sort_by_z_index(this: Sprite2D, that: Sprite2D) -> bool:
    return this.z_index < that.z_index
