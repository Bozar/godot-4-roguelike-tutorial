class_name PcFov
extends Node2D


const NO_FOV: bool = false


var _fov_map: Dictionary


func _ready() -> void:
    _fov_map = Map2D.init_map(false)


func render_fov(pc: Sprite2D) -> void:
    if NO_FOV:
        return

    var pc_coord: Vector2i = ConvertCoord.get_coord(pc)
    var this_coord: Vector2i = Vector2i(0, 0)

    DiamondFov.get_fov_map(pc_coord, GameData.PC_SIGHT_RANGE, _fov_map)

    for x: int in range(0, DungeonSize.MAX_X):
        for y: int in range(DungeonSize.MAX_Y):
            this_coord.x = x
            this_coord.y = y
            _set_sprite_color(this_coord, _fov_map)


func _set_sprite_color(coord: Vector2i, fov_map: Dictionary) -> void:
    if _is_in_sight(coord, fov_map):
        for i: Sprite2D in SpriteState.get_sprites_by_coord(coord):
            VisualEffect.set_light_color(i)
    else:
        for i: Sprite2D in SpriteState.get_sprites_by_coord(coord):
            VisualEffect.set_dark_color(i)


func _is_in_sight(coord: Vector2i, fov_map: Dictionary) -> bool:
    if Map2D.is_in_map(fov_map, coord):
        return fov_map[coord.x][coord.y]
    return false
