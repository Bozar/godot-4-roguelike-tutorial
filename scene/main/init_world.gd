class_name InitWorld
extends Node2D


const INDICATOR_OFFSET: int = 32


func create_world() -> void:
    var tagged_sprites: Array = []
    var pc_coord: Vector2i

    pc_coord = _create_pc(tagged_sprites)
    _create_floor(tagged_sprites)
    _create_indicator(pc_coord, tagged_sprites)

    SpriteFactory.sprite_created.emit(tagged_sprites)


func _create_pc(tagged_sprites: Array) -> Vector2i:
    var pc_coord: Vector2i = Vector2i(0, 0)

    tagged_sprites.push_back(SpriteFactory.create_actor(SubTag.PC, pc_coord,
            false))
    return pc_coord


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
