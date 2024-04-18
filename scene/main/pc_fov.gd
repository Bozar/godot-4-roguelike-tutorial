class_name PcFov
extends Node2D


const NO_FOV: bool = false
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


func _set_sprite_color(coord: Vector2i, fov_map: Dictionary) -> void:
    if _is_fov_flag(coord, fov_map, IS_IN_SIGHT_FLAG):
        for i: Sprite2D in SpriteState.get_sprites_by_coord(coord):
            VisualEffect.set_light_color(i)
    else:
        for i: Sprite2D in SpriteState.get_sprites_by_coord(coord):
            VisualEffect.set_dark_color(i)


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
