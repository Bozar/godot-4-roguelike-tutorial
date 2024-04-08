class_name PlayerInput
extends Node2D


signal action_pressed(input_tag: InputTag)


func _unhandled_input(event: InputEvent) -> void:
    if _is_move_actions(event):
        return


func _is_move_actions(event: InputEvent) -> bool:
    for i: StringName in InputTag.MOVE_ACTIONS:
        if event.is_action_pressed(i):
            action_pressed.emit(i)
            return true
    return false
