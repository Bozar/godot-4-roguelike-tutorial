class_name MainScreen
extends Node2D


func _ready() -> void:
    _connect_signals(NodeReference.SIGNAL_CONNECTIONS)
    _connect_nodes(NodeReference.NODE_CONNECTIONS)

    if TransferData.load_setting_file:
        SettingFile.load()
        TransferData.set_load_setting_file(false)

    VisualEffect.set_background_color()
    $RandomNumber.set_initial_seed(TransferData.rng_seed)
    $InitWorld.create_world()
    $Sidebar.init_gui()
    $HelpScreen.init_gui()
    $DebugScreen.init_gui()
    $Schedule.start_next_turn()


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


func _connect_nodes(node_connections: Dictionary) -> void:
    var source_reference: String
    var target_nodes: Array

    for source_node: String in node_connections.keys():
        source_reference = "_ref_" + Array(source_node.split("/")).pop_back()
        target_nodes = node_connections[source_node]
        for target_node: String in target_nodes:
            get_node(target_node)[source_reference] = get_node(source_node)
