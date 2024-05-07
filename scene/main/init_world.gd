class_name InitWorld
extends Node2D


const INDICATOR_OFFSET: int = 32

const PATH_TO_PREFAB: StringName = "res://resource/dungeon_prefab/"
const MAX_PREFABS_PER_ROW: int = 3
const MAX_PREFABS: int = 9
const EDIT_TAGS: Array = [
    DungeonPrefab.FLIP_VERTICALLY, DungeonPrefab.FLIP_HORIZONTALLY,
]


const WALL_CHAR: StringName = "#"
const RANDOM_WALL_CHAR: StringName = "+"
const BULLET_CHAR: StringName = "?"
const HOUND_CHAR: StringName = "G"


var _ref_RandomNumber: RandomNumber


func create_world() -> void:
    var tagged_sprites: Array = []
    var occupied_grids: Dictionary = Map2D.init_map(false)
    var pc_coord: Vector2i

    _create_floor(tagged_sprites)
    _create_from_file(PATH_TO_PREFAB, occupied_grids, tagged_sprites)
    pc_coord = _create_pc(occupied_grids, tagged_sprites)
    _create_indicator(pc_coord, tagged_sprites)

    SpriteFactory.sprite_created.emit(tagged_sprites)


func _create_pc(occupied_grids: Dictionary, tagged_sprites: Array) -> Vector2i:
    var coord: Vector2i = Vector2i.ZERO

    while true:
        coord.x = _ref_RandomNumber.get_int(0, DungeonSize.MAX_X)
        coord.y = _ref_RandomNumber.get_int(0, DungeonSize.MAX_Y)
        if not occupied_grids[coord.x][coord.y]:
            break

    tagged_sprites.push_back(SpriteFactory.create_actor(SubTag.PC, coord,
            false))
    return coord


func _create_floor(tagged_sprites: Array) -> void:
    for x: int in range(0, DungeonSize.MAX_X):
        for y: int in range(0, DungeonSize.MAX_Y):
            tagged_sprites.push_back(SpriteFactory.create_ground(
                    SubTag.DUNGEON_FLOOR, Vector2i(x, y), false))


func _create_indicator(coord: Vector2i, tagged_sprites: Array) -> void:
    var indicators: Dictionary = {
        SubTag.INDICATOR_TOP: [
            Vector2i(coord.x, 0), Vector2i(0, -INDICATOR_OFFSET)
        ],
        SubTag.INDICATOR_BOTTOM: [
            Vector2i(coord.x, DungeonSize.MAX_Y - 1),
            Vector2i(0, INDICATOR_OFFSET)
        ],
        SubTag.INDICATOR_LEFT: [
            Vector2i(0, coord.y), Vector2i(-INDICATOR_OFFSET, 0)
        ],
    }
    var new_coord: Vector2i
    var new_offset: Vector2i

    for i: StringName in indicators:
        new_coord = indicators[i][0]
        new_offset = indicators[i][1]
        tagged_sprites.push_back(CreateSprite.create(MainTag.INDICATOR,
                i, new_coord, new_offset))


func _create_from_file(path_to_file: String, occupied_grids: Dictionary,
        tagged_sprites: Array) -> void:
    var prefabs: Array = FileIo.get_files(path_to_file)
    var file_name: String
    var parsed: ParsedFile
    var packed_prefab: PackedPrefab
    var shift_coord: Vector2i = Vector2i(0, 0)
    var row: int = 0

    ArrayHelper.shuffle(prefabs, _ref_RandomNumber)
    prefabs.resize(MAX_PREFABS)
    for i: int in range(0, prefabs.size()):
        file_name = prefabs[i]
        parsed = FileIo.read_as_line(file_name)
        if not parsed.parse_success:
            return

        # print(file_name)
        packed_prefab = DungeonPrefab.get_prefab(parsed.output_line,
                _get_edit_tags(EDIT_TAGS))

        if (i > 0) and (i % MAX_PREFABS_PER_ROW == 0):
            row += 1
        shift_coord.x = (i - MAX_PREFABS_PER_ROW * row) * packed_prefab.max_x
        shift_coord.y = row * packed_prefab.max_y

        _create_from_prefab(packed_prefab, shift_coord, occupied_grids,
                tagged_sprites)


func _create_from_prefab(packed_prefab: PackedPrefab, shift_coord: Vector2i,
        occupied_grids: Dictionary, tagged_sprites: Array) -> void:
    var coord: Vector2i = Vector2i(0, 0)
    var random_wall_coords: Array = []

    for y: int in range(0, packed_prefab.max_y):
        for x: int in range(0, packed_prefab.max_x):
            coord.x = x + shift_coord.x
            coord.y = y + shift_coord.y
            _create_from_character(packed_prefab.prefab[x][y], coord,
                    occupied_grids, random_wall_coords, tagged_sprites)
    _create_random_wall(random_wall_coords, occupied_grids, tagged_sprites)


func _create_from_character(character: String, coord: Vector2i,
        occupied_grids: Dictionary, random_wall_coords: Array,
        tagged_sprites: Array) -> void:
    match character:
        WALL_CHAR:
            occupied_grids[coord.x][coord.y] = true
            tagged_sprites.push_back(SpriteFactory.create_building(
                    SubTag.WALL, coord, false))
        HOUND_CHAR:
            tagged_sprites.push_back(SpriteFactory.create_actor(
                    SubTag.HOUND, coord, false))
        BULLET_CHAR:
            tagged_sprites.push_back(SpriteFactory.create_trap(
                    SubTag.BULLET, coord, false))
        RANDOM_WALL_CHAR:
            random_wall_coords.push_back(coord)


func _get_edit_tags(edit_tags: Array) -> Array:
    var tags: Array = []

    for i: int in edit_tags:
        if _ref_RandomNumber.get_percent_chance(50):
            tags.push_back(i)
    return tags


func _create_random_wall(coords: Array, occupied_grids: Dictionary,
        tagged_sprites: Array) -> void:
    var max_walls: int = floor(coords.size() * 0.5)

    ArrayHelper.shuffle(coords, _ref_RandomNumber)
    coords.resize(max_walls)
    for i: Vector2i in coords:
        occupied_grids[i.x][i.y] = true
        tagged_sprites.push_back(SpriteFactory.create_building(SubTag.WALL, i,
                false))
