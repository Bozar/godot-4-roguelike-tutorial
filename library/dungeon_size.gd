class_name DungeonSize


const MAX_X: int = 21
const MAX_Y: int = 15

const CENTER_X: int = 10
const CENTER_Y: int = 7

const MIN_VALID_COORD: Vector2i = Vector2i(0, 0)
const MAX_VALID_COORD: Vector2i = Vector2i(MAX_X - 1, MAX_Y - 1)


static func is_in_dungeon(coord: Vector2i) -> bool:
    return coord == coord.clamp(MIN_VALID_COORD, MAX_VALID_COORD)
