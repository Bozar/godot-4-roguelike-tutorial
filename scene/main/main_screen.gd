class_name MainScreen
extends Node2D


# https://coolors.co/f8f9fa-e9ecef-dee2e6-ced4da-adb5bd-6c757d-495057-343a40-212529
# https://coolors.co/d8f3dc-b7e4c7-95d5b2-74c69d-52b788-40916c-2d6a4f-1b4332-081c15
# https://coolors.co/f8b945-dc8a14-b9690b-854e19-a03401
const PALETTE: Dictionary = {
    &"BACKGROUND": "#212529",
    &"LIGHT_GREY": "#ADB5BD",
    &"GREEN": "#52B788",
    &"DARK_GREEN": "#2D6A4F",
    &"GREY": "#6C757D",
    &"DARK_GREY": "#343A40",
    &"ORANGE": "#F8B945",
    &"DARK_ORANGE": "#854E19",
    &"DEBUG": "#FE4A49",
}


func _ready() -> void:
    RenderingServer.set_default_clear_color(PALETTE["BACKGROUND"])
    _create_pc()


func _create_pc() -> void:
    # var pc: Sprite2D = preload("res://sprite/pc.tscn").instantiate()
    var pc: PackedScene = preload("res://sprite/pc.tscn")
    var new_pc: Sprite2D
    var x: int = 0

    for i: StringName in PALETTE.keys():
        new_pc = pc.instantiate()
        new_pc.position = Vector2i(50 + x, 50)
        new_pc.modulate = PALETTE[i]
        add_child(new_pc)
        x += 30
