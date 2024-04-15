class_name ActorAction
extends Node2D


func _on_Schedule_turn_started(sprite: Sprite2D) -> void:
    if sprite.is_in_group(SubTag.PC):
        # print("pc")
        return
    # print("%s: Woof!" % sprite.name)
    ScheduleHelper.start_next_turn()
