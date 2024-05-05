class_name PlayerInput
extends Node2D


signal action_pressed(input_tag: InputTag)


func _unhandled_input(event: InputEvent) -> void:
    if _is_quit_game(event):
        return
    elif _is_copy_seed(event):
        return
    elif _is_move_actions(event):
        return
    elif _is_aim(event):
        return
    elif _is_restart_game(event):
        return
    elif _is_replay_game(event):
        return


func _is_move_actions(event: InputEvent) -> bool:
    for i: StringName in InputTag.MOVE_ACTIONS:
        if event.is_action_pressed(i):
            action_pressed.emit(i)
            return true
    return false


func _is_aim(event: InputEvent) -> bool:
    if event.is_action_pressed(InputTag.AIM):
        action_pressed.emit(InputTag.AIM)
        return true
    return false


func _is_restart_game(event: InputEvent) -> bool:
    if event.is_action_pressed(InputTag.RESTART_GAME):
        action_pressed.emit(InputTag.RESTART_GAME)
        EndGame.reload()
        return true
    return false


func _is_replay_game(event: InputEvent) -> bool:
    if event.is_action_pressed(InputTag.REPLAY_GAME):
        action_pressed.emit(InputTag.REPLAY_GAME)
        EndGame.reload()
        return true
    return false


func _is_quit_game(event: InputEvent) -> bool:
    if event.is_action_pressed(InputTag.QUIT_GAME):
        EndGame.quit()
        return true
    return false


func _is_copy_seed(event: InputEvent) -> bool:
    if event.is_action_pressed(InputTag.COPY_SEED):
        action_pressed.emit(InputTag.COPY_SEED)
        return true
    return false


func _on_Schedule_turn_started(sprite: Sprite2D) -> void:
    set_process_unhandled_input(sprite.is_in_group(SubTag.PC))
