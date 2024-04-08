class_name MainScreen
extends Node2D


const START_X: int = 50
const START_Y: int = 54
const STEP_X: int = 26
const STEP_Y: int = 34

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

    new_pc.position = _get_position_from_coord(new_position)
    new_pc.modulate = Palette.get_color({}, MainTag.ACTOR, true)
    new_pc.add_to_group(PC_TAG)
    add_child(new_pc)


func _get_position_from_coord(coord: Vector2i,
        offset: Vector2i = Vector2i(0, 0)) -> Vector2i:
    var new_x: int = START_X + STEP_X * coord.x + offset.x
    var new_y: int = START_Y + STEP_Y * coord.y + offset.y
    return Vector2i(new_x, new_y)


func _get_coord_from_sprite(sprite: Sprite2D) -> Vector2i:
    var new_x: int = floor((sprite.position.x - START_X) / STEP_X)
    var new_y: int = floor((sprite.position.y - START_Y) / STEP_Y)
    return Vector2i(new_x, new_y)


func _move_pc(direction: StringName) -> void:
    var pc: Sprite2D = get_tree().get_first_node_in_group(PC_TAG)
    var coord: Vector2i = _get_coord_from_sprite(pc)

    match direction:
        MOVE_LEFT:
            coord += Vector2i.LEFT
        MOVE_RIGHT:
            coord += Vector2i.RIGHT
        MOVE_UP:
            coord += Vector2i.UP
        MOVE_DOWN:
            coord += Vector2i.DOWN
    pc.position = _get_position_from_coord(coord)
