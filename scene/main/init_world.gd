class_name InitWorld
extends Node2D


func create_world() -> void:
    var tagged_sprites: Array = []

    _create_pc(tagged_sprites)
    _create_floor(tagged_sprites)

    SpriteFactory.sprite_created.emit(tagged_sprites)


func _create_pc(tagged_sprites: Array) -> void:
    var pc_coord: Vector2i = Vector2i(0, 0)

    tagged_sprites.push_back(SpriteFactory.create_actor(SubTag.PC, pc_coord,
            false))


func _create_floor(tagged_sprites: Array) -> void:
    for x: int in range(0, DungeonSize.MAX_X):
        for y: int in range(0, DungeonSize.MAX_Y):
            tagged_sprites.push_back(SpriteFactory.create_ground(
                    SubTag.DUNGEON_FLOOR, Vector2i(x, y), false))
