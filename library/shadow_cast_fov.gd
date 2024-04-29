class_name ShadowCastFov


# Recursive Shadow Casting Field of View
#
# http://www.roguebasin.com/index.php?title=FOV_using_recursive_shadowcasting
#
#   \ 5 | 6 /
#    \  |  /
#   4 \ | / 7
# ------@------>
#   3 / | \ 0
#    /  |  \
#   / 2 | 1 \
#       |
#       v
#


const MIN_X: int = 0
const MIN_SLOPE: float = 0.0
const MAX_SLOPE: float = 1.0

const OCTANT_0: int = 0b00_00_00_01
const OCTANT_1: int = 0b00_00_00_10
const OCTANT_2: int = 0b00_00_01_00
const OCTANT_3: int = 0b00_00_10_00
const OCTANT_4: int = 0b00_01_00_00
const OCTANT_5: int = 0b00_10_00_00
const OCTANT_6: int = 0b01_00_00_00
const OCTANT_7: int = 0b10_00_00_00

const OCTANT_FLAGS: Array = [
    OCTANT_0,
    OCTANT_1,
    OCTANT_2,
    OCTANT_3,
    OCTANT_4,
    OCTANT_5,
    OCTANT_6,
    OCTANT_7,
]


# _set_fov_value(coord: Vector2i, fov_map: Dictionary, fov_flag: int,
#       is_truthy: bool) -> void
# is_obstacle(from_coord: Vector2i, to_coord: Vector2i, opt_args: Array) -> bool
static func get_fov_map(source: Vector2i, out_fov_map: Dictionary,
        set_fov_value: Callable, is_obstacle: Callable, is_obstacle_args: Array,
        fov_data: FovData) -> void:
    var coord: Vector2i = Vector2i(0, 0)

    for x: int in range(0, DungeonSize.MAX_X):
        for y: int in range(0, DungeonSize.MAX_Y):
            coord.x = x
            coord.y = y
            set_fov_value.call(coord, out_fov_map, PcFov.IS_IN_SIGHT_FLAG,
                    false)
    set_fov_value.call(source, out_fov_map, PcFov.IS_IN_SIGHT_FLAG, true)

    for i: int in OCTANT_FLAGS:
        if i & fov_data.octant_flags:
            _set_octant_map(source, fov_data.sight_range, set_fov_value,
                    is_obstacle, is_obstacle_args, out_fov_map,
                    MIN_X, MIN_SLOPE, MAX_SLOPE, i)


static func _set_octant_map(source: Vector2i, sight_range: int,
        set_fov_value: Callable, is_obstacle: Callable, is_obstacle_args: Array,
        out_fov_map: Dictionary, min_x: int, min_slope: float, max_slope: float,
        octant_flag: int) -> void:
    var break_loop: bool
    var hit_obstacle: bool
    var new_min_slope: float = min_slope
    var new_max_slope: float = max_slope
    var min_y: int
    var max_y: int
    var coord: Vector2i = Vector2i(0, 0)

    # Start scanning one grid away from source.
    for x: int in range(min_x + 1, sight_range + 1):
        # By default, scan only one row or column.
        break_loop = true
        hit_obstacle = false
        min_y = floor(x * new_min_slope)
        max_y = ceil(x * new_max_slope)

        for y: int in range(max_y, min_y - 1, -1):
            coord = ShadowCastFov._convert_coord(source, x, y, octant_flag)
            # coord.x = source.x + x
            # coord.y = source.y + y
            if not Map2D.is_in_map(coord, out_fov_map):
                continue
            # The current row or column is always visible.
            set_fov_value.call(coord, out_fov_map, PcFov.IS_IN_SIGHT_FLAG, true)

            if is_obstacle.call(source, coord, is_obstacle_args):
                # If this is not the first obstacle in a row, go past it.
                if hit_obstacle:
                    continue
                hit_obstacle = true

                # `new_min_slope` should be one grid lower than the first
                # obstacle, and higher than `new_max_slope`.
                if y + 1 > max_y:
                    continue
                new_min_slope = _get_slope(x, y + 1)
                # Call `_set_octant_map` recursively, starting from `x`. Note
                # that actual scanning begins at `x + 1`.
                _set_octant_map(source, sight_range, set_fov_value,
                        is_obstacle, is_obstacle_args, out_fov_map, x,
                        new_min_slope, new_max_slope, octant_flag)
            else:
                # Update `new_max_slope` when reach the first unoccupied grid.
                if hit_obstacle:
                    hit_obstacle = false
                    new_max_slope = _get_slope(x, y)
                # Scan the next row or column (`x + 1`) if and only if the last
                # grid is unoccupied.
                if y == min_y:
                    break_loop = false
                    new_min_slope = _get_slope(x, y)
        if break_loop:
            break


static func _get_slope(delta_x: int, delta_y: int) -> float:
    return delta_y * 1.0 / delta_x


static func _convert_coord(source: Vector2i, x_shift: int, y_shift: int,
        octant_flag: int) -> Vector2i:
    var coord: Vector2i = source

    match octant_flag:
        OCTANT_0:
            coord.x = source.x + x_shift
            coord.y = source.y + y_shift
        OCTANT_1:
            coord.x = source.x + y_shift
            coord.y = source.y + x_shift
        OCTANT_2:
            coord.x = source.x - y_shift
            coord.y = source.y + x_shift
        OCTANT_3:
            coord.x = source.x - x_shift
            coord.y = source.y + y_shift
        OCTANT_4:
            coord.x = source.x - x_shift
            coord.y = source.y - y_shift
        OCTANT_5:
            coord.x = source.x - y_shift
            coord.y = source.y - x_shift
        OCTANT_6:
            coord.x = source.x + y_shift
            coord.y = source.y - x_shift
        OCTANT_7:
            coord.x = source.x + x_shift
            coord.y = source.y - y_shift
    return coord


class FovData:
    var octant_flags: int = 0b11_11_11_11
    var sight_range: int

    func _init(sight_range_: int) -> void:
        sight_range = sight_range_
