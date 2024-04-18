class_name Map2D


static func init_map(value: Variant = null, max_x: int = DungeonSize.MAX_X,
        max_y: int = DungeonSize.MAX_Y) -> Dictionary:
    var map_2d: Dictionary = {}
    var column: Array

    for x: int in range(0, max_x):
        column = []
        column.resize(max_y)
        column.fill(value)
        map_2d[x] = column
    return map_2d


static func reset_map(value: Variant, map_2d: Dictionary) -> void:
    var column: Array

    for x: int in map_2d.keys():
        column = map_2d[x]
        column.fill(value)


static func is_in_map(coord: Vector2i, map_2d: Dictionary) -> bool:
    var column: Array

    if map_2d.has(coord.x):
        column = map_2d[coord.x]
        return (coord.y >= 0) and (coord.y < column.size())
    return false
