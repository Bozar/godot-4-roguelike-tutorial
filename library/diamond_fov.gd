class_name DiamondFov


# _set_fov_value(coord: Vector2i, fov_map: Dictionary, fov_flag: int,
#       is_truthy: bool) -> void
static func get_fov_map(source: Vector2i, out_fov_map: Dictionary,
        set_fov_value: Callable, sight_range: int) -> void:
    var column: Array
    var coord: Vector2i = Vector2i(0, 0)

    for x: int in out_fov_map.keys():
        column = out_fov_map[x]
        for y: int in range(0, column.size()):
            coord.x = x
            coord.y = y
            set_fov_value.call(coord, out_fov_map, PcFov.IS_IN_SIGHT_FLAG,
                    ConvertCoord.is_in_range(source, coord, sight_range))
