class_name MainScreen
extends Node2D


const PC_TAG: StringName = &"pc"

const MOVE_LEFT: StringName = &"move_left"
const MOVE_RIGHT: StringName = &"move_right"
const MOVE_UP: StringName = &"move_up"
const MOVE_DOWN: StringName = &"move_down"

const MOVE_INPUTS: Array[StringName] = [
    MOVE_LEFT,
    MOVE_RIGHT,
    MOVE_UP,
    MOVE_DOWN,
]


func _ready() -> void:
    RenderingServer.set_default_clear_color(Palette.get_color({},
            MainTag.BACKGROUND, true))
    _create_pc()


func _unhandled_input(event: InputEvent) -> void:
    for i: StringName in MOVE_INPUTS:
        if event.is_action_pressed(i):
            _move_pc(i)


func _create_pc() -> void:
    var new_pc: Sprite2D = preload("res://sprite/pc.tscn").instantiate()
    var new_position: Vector2i = Vector2i(0, 0)

    new_pc.position = ConvertCoord.get_position(new_position)
    new_pc.modulate = Palette.get_color({}, MainTag.ACTOR, true)
    new_pc.add_to_group(PC_TAG)
    add_child(new_pc)


func _move_pc(direction: StringName) -> void:
    var pc: Sprite2D = get_tree().get_first_node_in_group(PC_TAG)
    var coord: Vector2i = ConvertCoord.get_coord(pc)

    match direction:
        MOVE_LEFT:
            coord += Vector2i.LEFT
        MOVE_RIGHT:
            coord += Vector2i.RIGHT
        MOVE_UP:
            coord += Vector2i.UP
        MOVE_DOWN:
            coord += Vector2i.DOWN
    pc.position = ConvertCoord.get_position(coord)
