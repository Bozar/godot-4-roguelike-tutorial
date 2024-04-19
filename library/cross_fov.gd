class_name CrossFov


# _set_fov_value(coord: Vector2i, fov_map: Dictionary, fov_flag: int,
#       is_truthy: bool) -> void
# is_obstacle(from_coord: Vector2i, to_coord: Vector2i, opt_args: Array) -> bool
static func get_fov_map(source: Vector2i, out_fov_map: Dictionary,
        set_fov_value: Callable, is_obstacle: Callable, is_obstacle_args: Array,
        fov_data: FovData) -> void:

    fov_data.min_y = _get_end_point(source, Vector2i.UP,
            is_obstacle, is_obstacle_args).y
    fov_data.min_x = _get_end_point(source, Vector2i.LEFT,
            is_obstacle, is_obstacle_args).x

    fov_data.max_y = _get_end_point(source, Vector2i.DOWN,
            is_obstacle, is_obstacle_args).y
    fov_data.max_x = _get_end_point(source, Vector2i.RIGHT,
            is_obstacle, is_obstacle_args).x

    _set_fov_map(source, out_fov_map, set_fov_value, fov_data)


static func _get_end_point(source: Vector2i, direction: Vector2i,
        is_obstacle: Callable, is_obstacle_args: Array) -> Vector2i:
    var coords: Array

    coords = CastRay.get_coords(source, source + direction, is_obstacle,
            is_obstacle_args)
    coords = CastRay.trim_coords(coords, true, false)
    if coords.is_empty():
        return source
    return coords.pop_back()


static func _set_fov_map(source: Vector2i, out_fov_map: Dictionary,
        set_fov_value: Callable, fov_data: FovData) -> void:
    var coord: Vector2i = Vector2i(0, 0)

    for x: int in range(0, DungeonSize.MAX_X):
        for y: int in range(0, DungeonSize.MAX_Y):
            coord.x = x
            coord.y = y
            if (x >= source.x - fov_data.half_width) \
                    and (x <= source.x + fov_data.half_width) \
                    and (y >= fov_data.min_y) and (y <= fov_data.max_y):
                set_fov_value.call(coord, out_fov_map, PcFov.IS_IN_SIGHT_FLAG,
                        true)
            elif (y >= source.y - fov_data.half_width) \
                    and (y <= source.y + fov_data.half_width) \
                    and (x >= fov_data.min_x) and (x <= fov_data.max_x):
                set_fov_value.call(coord, out_fov_map, PcFov.IS_IN_SIGHT_FLAG,
                        true)
            else:
                set_fov_value.call(coord, out_fov_map, PcFov.IS_IN_SIGHT_FLAG,
                        false)


class FovData:
    var half_width: int:
        get:
            return _half_width
    var up: int:
        get:
            return _up
    var down: int:
        get:
            return _down
    var left: int:
        get:
            return _left
    var right: int:
        get:
            return _right

    var min_x: int
    var max_x: int
    var min_y: int
    var max_y: int


    var _half_width: int
    var _up: int
    var _down: int
    var _left: int
    var _right: int


    func _init(half_width_: int, up_: int, right_: int, down_: int,
            left_: int) -> void:
        _half_width = half_width_
        _up = up_
        _right = right_
        _down = down_
        _left = left_
