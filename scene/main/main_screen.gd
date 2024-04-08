class_name MainScreen
extends Node2D


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
    _connect_signals(NodeReference.SIGNAL_CONNECTIONS)
    RenderingServer.set_default_clear_color(Palette.get_color({},
            MainTag.BACKGROUND, true))
    _create_pc()


func _unhandled_input(event: InputEvent) -> void:
    for i: StringName in MOVE_INPUTS:
        if event.is_action_pressed(i):
            _move_pc(i)


func _create_pc() -> void:
    SpriteFactory.create_actor(SubTag.PC, Vector2i(0, 0), true)


func _move_pc(direction: StringName) -> void:
    var pc: Sprite2D = get_tree().get_first_node_in_group(SubTag.PC)
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


func _connect_signals(signal_connections: Dictionary) -> void:
    var signals_from_one_node: Dictionary
    var target_nodes: Array
    var source_signal: Signal
    var target_function: Callable

    for source_node: String in signal_connections.keys():
        signals_from_one_node = signal_connections[source_node]

        for signal_name: String in signals_from_one_node.keys():
            target_nodes = signals_from_one_node[signal_name]

            for target_node: String in target_nodes:
                source_signal = get_node(source_node)[signal_name]
                target_function = get_node(target_node)["_on_" +
                        Array(source_node.split("/")).pop_back() + "_" +
                        signal_name]

                if source_signal.connect(target_function) == \
                        ERR_INVALID_PARAMETER:
                    push_error("Signal error: %s -> %s, %s." %
                            [source_node, target_node, signal_name])
