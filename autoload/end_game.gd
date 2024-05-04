# class_name EndGame
extends Node2D


const PATH_TO_ROOT: String = "res://scene/main/main_screen.tscn"


func reload() -> void:
    var new_scene: Node2D = preload(PATH_TO_ROOT).instantiate()
    var old_scene: Node2D = get_tree().current_scene

    SpriteFactory.clear_data()

    get_tree().root.add_child(new_scene)
    get_tree().current_scene = new_scene

    get_tree().root.remove_child(old_scene)
    old_scene.queue_free()


func quit() -> void:
    get_tree().quit()
