class_name Schedule
extends Node2D


signal turn_started(sprite: Sprite2D)


var _game_over: bool = false
# var _test_counter: int = 0


func start_next_turn() -> void:
    if _game_over:
        return
    turn_started.emit(_point_to_next_sprite())
    # print(_test_counter)
    # _test_counter += 1


func _point_to_next_sprite() -> Sprite2D:
    # if _test_counter < 5:
    #     return SpriteState.get_sprites_by_sub_tag(SubTag.PC)[0]
    # return SpriteState.get_sprites_by_sub_tag(SubTag.DUNGEON_FLOOR)[0]
    return SpriteState.get_sprites_by_sub_tag(SubTag.PC)[0]
