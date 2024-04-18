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
