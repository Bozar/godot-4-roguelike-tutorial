class_name DijkstraPathfinding


const DESTINATION: int = 0
const OBSTACLE: int = 9999
const UNKNOWN: int = -9999


static func get_coords(map_2d: Dictionary, start_coord: Vector2i,
        step_length: int) -> Array:
    var neighbor: Array = ConvertCoord.get_diamond_coords(start_coord,
            step_length)
    var coord: Vector2i
    var min_distance: int = OBSTACLE
    var current_index: int = 0

    for i: int in range(0, neighbor.size()):
        coord = neighbor[i]
        if Map2D.is_in_map(coord, map_2d) and \
                _is_valid_distance(map_2d, coord, OBSTACLE):
            if map_2d[coord.x][coord.y] < min_distance:
                min_distance = map_2d[coord.x][coord.y]
                ArrayHelper.swap_element(neighbor, 0, i)
                current_index = 1
            elif map_2d[coord.x][coord.y] == min_distance:
                ArrayHelper.swap_element(neighbor, current_index, i)
                current_index += 1

    neighbor.resize(current_index)
    return neighbor


# is_obstacle(coord: Vector2i, is_obstacle_args: Array) -> bool
static func set_obstacle_map(map_2d: Dictionary, is_obstacle: Callable,
        is_obstacle_args: Array) -> void:
    var coord: Vector2i = Vector2i(0, 0)
    var column: Array

    for x: int in range(0, map_2d.size()):
        column = map_2d[x]
        for y: int in range(0, column.size()):
            coord.x = x
            coord.y = y
            if is_obstacle.call(coord, is_obstacle_args):
                map_2d[x][y] = OBSTACLE
            else:
                map_2d[x][y] = UNKNOWN


static func set_distance_map(map_2d: Dictionary, end_points: Array) -> void:
    if end_points.size() < 1:
        return

    var coord: Vector2i = end_points.pop_front()
    var neighbor: Array = ConvertCoord.get_diamond_coords(coord, 1)

    for i: Vector2i in neighbor:
        if not Map2D.is_in_map(i, map_2d):
            continue
        if map_2d[i.x][i.y] == UNKNOWN:
            map_2d[i.x][i.y] = _get_distance(map_2d, i)
            end_points.push_back(i)
    set_distance_map(map_2d, end_points)


static func set_destination(map_2d: Dictionary, destinations: Array) -> void:
    for i: Vector2i in destinations:
        map_2d[i.x][i.y] = DESTINATION


static func _get_distance(map_2d: Dictionary, center_coord: Vector2i) -> int:
    var neighbor: Array = ConvertCoord.get_diamond_coords(center_coord, 1)
    var min_distance: int = OBSTACLE

    for i: Vector2i in neighbor:
        if _is_valid_distance(map_2d, i, min_distance):
            min_distance = map_2d[i.x][i.y]
    min_distance = min(min_distance + 1, OBSTACLE)
    return min_distance


static func _is_valid_distance(map_2d: Dictionary, coord: Vector2i,
        max_distance: int) -> bool:
    return Map2D.is_in_map(coord, map_2d) and \
            (map_2d[coord.x][coord.y] < max_distance) and \
            (map_2d[coord.x][coord.y] > UNKNOWN)
