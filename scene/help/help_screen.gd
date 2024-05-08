class_name HelpScreen
extends CustomMarginContainer


const SCROLL_LINE: int = 20
const SCROLL_PAGE: int = 300

const SCROLL_TEMPLATE: String = "%sScroll"
const LABEL_TEMPLATE: String = "%sScroll/%sLabel"

const ORDERED_GUIS: Array = [
    "Keybinding",
    "Gameplay",
    "Introduction",
]
const ORDERED_HELP_FILES: Array = [
    "res://user/doc/keybinding.md",
    "res://user/doc/gameplay.md",
    "res://user/doc/introduction.md",
]


var _current_index: int = 0
var _guis: Array = []


func _ready() -> void:
    visible = false
    size = Vector2(800, 600)
    add_theme_constant_override("margin_left", 30)
    add_theme_constant_override("margin_top", 30)
    add_theme_constant_override("margin_right", 30)
    add_theme_constant_override("margin_bottom", 30)


func init_gui() -> void:
    var label: CustomLabel
    var file_name: String
    var parsed_file: ParsedFile
    var scroll: ScrollContainer

    for i: String in ORDERED_GUIS:
        _guis.push_back([
            get_node(SCROLL_TEMPLATE % i),
            get_node(LABEL_TEMPLATE % [i, i]),
        ])

    for i: int in range(0, ORDERED_GUIS.size()):
        label = _get_label(i)
        label.init_gui()

        file_name = ORDERED_HELP_FILES[i]
        parsed_file = FileIo.read_as_text(file_name)
        if parsed_file.parse_success:
            label.text = parsed_file.output_text

        scroll = _get_scroll(i)
        scroll.mouse_filter = Control.MOUSE_FILTER_IGNORE


func _on_PlayerInput_action_pressed(input_tag: StringName) -> void:
    match input_tag:
        InputTag.OPEN_HELP_MENU:
            visible = true
            _switch_screen(input_tag)
        InputTag.CLOSE_MENU:
            visible = false
        InputTag.NEXT_SCREEN:
            _switch_screen(input_tag)
        InputTag.PREVIOUS_SCREEN:
            _switch_screen(input_tag)
        InputTag.PAGE_DOWN:
            _scroll_screen(input_tag)
        InputTag.PAGE_UP:
            _scroll_screen(input_tag)
        InputTag.LINE_DOWN:
            _scroll_screen(input_tag)
        InputTag.LINE_UP:
            _scroll_screen(input_tag)
        InputTag.PAGE_TOP:
            _scroll_screen(input_tag)
        InputTag.PAGE_BOTTOM:
            _scroll_screen(input_tag)


func _switch_screen(input_tag: StringName) -> void:
    var move_step: int = 0
    var label: CustomLabel
    var scroll: ScrollContainer

    match input_tag:
        InputTag.NEXT_SCREEN:
            move_step = 1
        InputTag.PREVIOUS_SCREEN:
            move_step = -1
        # Move to screen 0.
        InputTag.OPEN_HELP_MENU:
            move_step = -_current_index

    label = _get_label(_current_index)
    scroll = _get_scroll(_current_index)

    label.visible = false
    scroll.mouse_filter = Control.MOUSE_FILTER_IGNORE

    _current_index = _get_new_index(_current_index, move_step, _guis.size())
    label = _get_label(_current_index)
    scroll = _get_scroll(_current_index)

    label.visible = true
    scroll.mouse_filter = Control.MOUSE_FILTER_PASS
    scroll.scroll_vertical = 0


func _scroll_screen(input_tag: StringName) -> void:
    var scroll: ScrollContainer = _get_scroll(_current_index)

    match input_tag:
        InputTag.PAGE_TOP:
            scroll.scroll_vertical = 0
        InputTag.PAGE_BOTTOM:
            scroll.scroll_vertical = \
                    scroll.get_v_scroll_bar().max_value as int
        _:
            scroll.scroll_vertical += _get_scroll_distance(input_tag)


func _get_new_index(this_index: int, move_step: int, max_index: int) -> int:
    var next_index: int = this_index + move_step

    if next_index >= max_index:
        return 0
    elif next_index < 0:
        return max_index - 1
    return next_index


func _get_scroll_distance(input_tag: StringName) -> int:
    var distance: int = 0

    match input_tag:
        InputTag.LINE_DOWN:
            distance = SCROLL_LINE
        InputTag.LINE_UP:
            distance = -SCROLL_LINE
        InputTag.PAGE_DOWN:
            distance = SCROLL_PAGE
        InputTag.PAGE_UP:
            distance = -SCROLL_PAGE
    return distance


func _get_scroll(gui_index: int) -> ScrollContainer:
    return _guis[gui_index][0]


func _get_label(gui_index: int) -> CustomLabel:
    return _guis[gui_index][1]
