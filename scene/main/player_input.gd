class_name PlayerInput
extends Node2D


signal action_pressed(input_tag: InputTag)


# HELP_FLAG | DEBUG_FLAG | GAME_OVER_FLAG | FUNCTION_FLAG | GAMEPLAY_FLAG
const GAMEPLAY_FLAG: int = 0b000_01
const FUNCTION_FLAG: int = 0b000_10
const GAME_OVER_FLAG: int = 0b001_00
const DEBUG_FLAG: int = 0b010_00
const HELP_FLAG: int = 0b100_00


var _input_flags: int = 0b000_11
var _previous_input_flags: int = _input_flags


func _unhandled_input(event: InputEvent) -> void:
    if _input_flags & FUNCTION_FLAG:
        if _is_quit_game(event):
            return
        elif _is_copy_seed(event):
            return
        elif _is_restart_game(event):
            return
        elif _is_replay_game(event):
            return
        elif _is_open_help_menu(event, _input_flags):
            return
        elif _is_open_debug_menu(event, _input_flags):
            return
    elif _input_flags & HELP_FLAG:
        if _is_close_menu(event, _previous_input_flags):
            return
        elif _is_switch_screen_inputs(event):
            return
        elif _is_scroll_page_inputs(event):
            return
    elif _input_flags & DEBUG_FLAG:
        if _is_close_menu(event, _previous_input_flags):
            return

    if _input_flags & GAMEPLAY_FLAG:
        if _is_move_actions(event):
            return
        elif _is_aim(event):
            return
        elif TransferData.wizard_mode:
            if _is_add_ammo(event):
                return
            elif _is_add_hit(event):
                return
    elif _input_flags & GAME_OVER_FLAG:
        if _is_start_new_game(event):
            return


func _on_Schedule_turn_started(sprite: Sprite2D) -> void:
    set_process_unhandled_input(sprite.is_in_group(SubTag.PC))


func _on_GameProgress_game_over(_player_win: bool) -> void:
    set_process_unhandled_input(true)
    _input_flags = _input_flags & ~GAMEPLAY_FLAG
    _input_flags = _input_flags | GAME_OVER_FLAG


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


func _is_start_new_game(event: InputEvent) -> bool:
    if event.is_action_pressed(InputTag.START_NEW_GAME):
        action_pressed.emit(InputTag.START_NEW_GAME)
        EndGame.reload()
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


func _is_add_ammo(event: InputEvent) -> bool:
    if event.is_action_pressed(InputTag.ADD_AMMO):
        action_pressed.emit(InputTag.ADD_AMMO)
        return true
    return false


func _is_add_hit(event: InputEvent) -> bool:
    if event.is_action_pressed(InputTag.ADD_HIT):
        action_pressed.emit(InputTag.ADD_HIT)
        return true
    return false


func _is_open_help_menu(event: InputEvent, previous_input_flags: int) -> bool:
    if event.is_action_pressed(InputTag.OPEN_HELP_MENU):
        action_pressed.emit(InputTag.OPEN_HELP_MENU)
        _previous_input_flags = previous_input_flags
        _input_flags = HELP_FLAG
        return true
    return false


func _is_open_debug_menu(event: InputEvent, previous_input_flags: int) -> bool:
    if event.is_action_pressed(InputTag.OPEN_DEBUG_MENU):
        action_pressed.emit(InputTag.OPEN_DEBUG_MENU)
        _previous_input_flags = previous_input_flags
        _input_flags = DEBUG_FLAG
        return true
    return false


func _is_close_menu(event: InputEvent, previous_input_flags: int) -> bool:
    if event.is_action_pressed(InputTag.CLOSE_MENU):
        action_pressed.emit(InputTag.CLOSE_MENU)
        _input_flags = previous_input_flags
        return true
    return false


func _is_switch_screen_inputs(event: InputEvent) -> bool:
    for i: StringName in InputTag.SWITCH_SCREEN_INPUTS:
        if event.is_action_pressed(i):
            action_pressed.emit(i)
            return true
    return false


func _is_scroll_page_inputs(event: InputEvent) -> bool:
    for i: StringName in InputTag.SCROLL_PAGE_INPUTS:
        if event.is_action_pressed(i):
            action_pressed.emit(i)
            return true
    return false
