class_name Schedule
extends Node2D


signal turn_started(sprite: Sprite2D)


var _game_over: bool = false
var _is_first_turn: bool = true
var _schedule: Dictionary
var _current_sprite: Sprite2D
var _pc: Sprite2D


func start_next_turn() -> void:
    if _game_over:
        return
    turn_started.emit(_point_to_next_sprite())


func _on_SpriteFactory_sprite_created(tagged_sprites: Array) -> void:
    var sprite: Sprite2D

    for i: TaggedSprite in tagged_sprites:
        sprite = i.sprite
        if not sprite.is_in_group(MainTag.ACTOR):
            continue

        if _schedule.is_empty():
            _schedule = LinkedList.init_list(sprite)
            _current_sprite = sprite
        else:
            LinkedList.insert_object(sprite, _current_sprite, _schedule)

        if (_pc == null) and sprite.is_in_group(SubTag.PC):
            _pc = sprite


func _on_SpriteFactory_sprite_removed(sprites: Array) -> void:
    for i: Sprite2D in sprites:
        if not i.is_in_group(MainTag.ACTOR):
            continue
        if i == _current_sprite:
            _current_sprite = LinkedList.get_previous_object(i, _schedule)
        LinkedList.remove_object(i, _schedule)


func _on_GameProgress_game_over(_player_win: bool) -> void:
    _game_over = true


func _point_to_next_sprite() -> Sprite2D:
    if _is_first_turn:
        _current_sprite = LinkedList.get_previous_object(_pc, _schedule)
        _is_first_turn = false
    _current_sprite = LinkedList.get_next_object(_current_sprite, _schedule)
    return _current_sprite
