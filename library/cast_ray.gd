class_name CastRay


# is_obstacle(source_coord: Vector2i, target_coord: Vector2i,
# is_obstacle_args: Array) -> bool
static func get_coords(source_coord: Vector2i, target_coord: Vector2i,
        is_obstacle: Callable, is_obstacle_args: Array) -> Array:
    var direction: Vector2i
    var ray_coords: Array = []
    var this_coord: Vector2i

    if source_coord.x == target_coord.x:
        if source_coord.y > target_coord.y:
            direction = Vector2i.UP
        elif source_coord.y < target_coord.y:
            direction = Vector2i.DOWN
    elif source_coord.y == target_coord.y:
        if source_coord.x > target_coord.x:
            direction = Vector2i.LEFT
        elif source_coord.x < target_coord.x:
            direction = Vector2i.RIGHT
    else:
        push_error("Invalid coords: %s, %s" % [source_coord, target_coord])
        return ray_coords

    this_coord = source_coord
    while true:
        ray_coords.push_back(this_coord)
        this_coord += direction
        if is_obstacle.call(source_coord, this_coord, is_obstacle_args):
            ray_coords.push_back(this_coord)
            break
    return ray_coords


# Remove starting point and/or the last coord if it is outside dungeon.
static func trim_coords(coords: Array, trim_head: bool, trim_tail: bool) \
        -> Array:
    var tail_coord: Vector2i

    if trim_head and (coords.size() > 1):
        coords = coords.slice(1)
    if trim_tail and (coords.size() > 0):
        tail_coord = coords.back()
        if not DungeonSize.is_in_dungeon(tail_coord):
            coords = coords.slice(0, -1)
    return coords
