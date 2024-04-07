class_name MainScreen
extends Node2D


func _ready() -> void:
    _create_pc()


func _create_pc() -> void:
    var pc: Sprite2D = preload("res://sprite/pc.tscn").instantiate()
    pc.position = Vector2i(50, 50)
    add_child(pc)
