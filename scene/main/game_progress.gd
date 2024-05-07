class_name GameProgress
extends Node2D


signal game_over(player_win: bool)


var _ref_RandomNumber: RandomNumber


var _spawn_duration: int = GameData.MAX_SPAWN_DURATION
var _grounds: Array = []
var _ground_index: int = 0


func try_spawn_npc(pc: Sprite2D) -> void:
    var index: int
    var coord: Vector2i

    if _count_npc() >= GameData.MAX_ENEMY_COUNT:
        return

    _spawn_duration -= 1
    if _spawn_duration > 0:
        return
    _spawn_duration = GameData.MAX_SPAWN_DURATION

    if _grounds.is_empty():
        _init_grids(_grounds, _ref_RandomNumber)
    index = _get_grid_index(_grounds, _ground_index, ConvertCoord.get_coord(pc))
    coord = _grounds[index]
    _ground_index = index + 1
    SpriteFactory.create_actor(SubTag.HOUND, coord, true)


func _count_npc() -> int:
    var actors: Array = SpriteState.get_sprites_by_tag(MainTag.ACTOR, "")
    var count: int = actors.size()

    for i: Sprite2D in actors:
        if i.is_in_group(SubTag.PC):
            count -= 1
    return count


func _init_grids(grids: Array, random: RandomNumber) -> void:
    var coord: Vector2i = Vector2i(0, 0)

    for x: int in range(0, DungeonSize.MAX_X):
        for y: int in range(0, DungeonSize.MAX_Y):
            coord.x = x
            coord.y = y
            if SpriteState.has_building_at_coord(coord):
                continue
            grids.push_back(coord)
    ArrayHelper.shuffle(grids, random)


func _get_grid_index(grids: Array, index: int, pc_coord: Vector2i) -> int:
    var new_coord: Vector2i
    var new_index: int = index

    while true:
        if new_index > grids.size():
            ArrayHelper.shuffle(grids, _ref_RandomNumber)
            new_index = 0

        new_coord = grids[new_index]
        if ConvertCoord.is_in_range(pc_coord, new_coord,
                GameData.MIN_DISTANCE_TO_PC) or \
                SpriteState.has_actor_at_coord(new_coord):
            new_index += 1
        else:
            break
    return new_index
