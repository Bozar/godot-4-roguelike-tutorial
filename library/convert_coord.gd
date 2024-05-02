class_name ConvertCoord


const START_X: int = 50
const START_Y: int = 54
const STEP_X: int = 26
const STEP_Y: int = 34


static func get_position(coord: Vector2i, offset: Vector2i = Vector2i(0, 0)) \
        -> Vector2i:
    var new_x: int = START_X + STEP_X * coord.x + offset.x
    var new_y: int = START_Y + STEP_Y * coord.y + offset.y
    return Vector2i(new_x, new_y)


static func get_coord(sprite: Sprite2D) -> Vector2i:
    var new_x: int = floor((sprite.position.x - START_X) / STEP_X)
    var new_y: int = floor((sprite.position.y - START_Y) / STEP_Y)
    return Vector2i(new_x, new_y)


static func get_range(this_coord: Vector2i, that_coord: Vector2i) -> int:
    return abs(this_coord.x - that_coord.x) + abs(this_coord.y - that_coord.y)


static func is_in_range(this_coord: Vector2i, that_coord: Vector2i,
        max_range: int) -> bool:
    return get_range(this_coord, that_coord) <= max_range


static func get_direction(from_coord: Vector2i, to_coord: Vector2i) -> Vector2i:
    if from_coord.x == to_coord.x:
        if to_coord.y < from_coord.y:
            return Vector2i.UP
        elif to_coord.y > from_coord.y:
            return Vector2i.DOWN
    elif from_coord.y == to_coord.y:
        if to_coord.x > from_coord.x:
            return Vector2i.RIGHT
        elif to_coord.x < from_coord.x:
            return Vector2i.LEFT
    return Vector2i.ZERO


static func get_diamond_coords(center: Vector2i, max_range: int) -> Array:
    var coords: Array[Vector2i] = []
    var coord: Vector2i
    var mirror: Vector2i

    for x: int in range(0, max_range + 1):
        for y: int in range(0, max_range + 1 - x):
            coord = Vector2i(x + center.x, y + center.y)
            coords.push_back(coord)
            if x != 0:
                mirror = Vector2i(center.x, center.y + y)
                coords.push_back(get_mirror_coord(coord, mirror))
            if y != 0:
                mirror = Vector2i(center.x + x, center.y)
                coords.push_back(get_mirror_coord(coord, mirror))
            if (x != 0) and (y != 0):
                coords.push_back(get_mirror_coord(coord, center))
    return coords


static func get_mirror_coord(coord: Vector2i, mirror: Vector2i) -> Vector2i:
    return Vector2i(mirror.x * 2 - coord.x, mirror.y * 2 - coord.y)
