class_name InputTag


const MOVE_LEFT: StringName = &"move_left"
const MOVE_RIGHT: StringName = &"move_right"
const MOVE_UP: StringName = &"move_up"
const MOVE_DOWN: StringName = &"move_down"

const AIM: StringName = &"aim"

const START_NEW_GAME: StringName = &"start_new_game"
const RESTART_GAME: StringName = &"restart_game"
const REPLAY_GAME: StringName = &"replay_game"
const QUIT_GAME: StringName = &"quit_game"
const COPY_SEED: StringName = &"copy_seed"

const ADD_AMMO: StringName = &"add_ammo"
const ADD_HIT: StringName = &"add_hit"

const OPEN_HELP_MENU: StringName = &"open_help_menu"
const OPEN_DEBUG_MENU: StringName = &"open_debug_menu"
const CLOSE_MENU: StringName = &"close_menu"

const NEXT_SCREEN: StringName = &"next_screen"
const PREVIOUS_SCREEN: StringName = &"previous_screen"

const PAGE_DOWN: StringName = &"page_down"
const PAGE_UP: StringName = &"page_up"
const LINE_DOWN: StringName = &"line_down"
const LINE_UP: StringName = &"line_up"
const PAGE_TOP: StringName = &"page_top"
const PAGE_BOTTOM: StringName = &"page_bottom"


const MOVE_ACTIONS: Array[StringName] = [
    MOVE_LEFT,
    MOVE_RIGHT,
    MOVE_UP,
    MOVE_DOWN,
]

const SWITCH_SCREEN_INPUTS: Array[StringName] = [
    NEXT_SCREEN,
    PREVIOUS_SCREEN,
]

const SCROLL_PAGE_INPUTS: Array[StringName] = [
    PAGE_DOWN,
    PAGE_UP,
    LINE_DOWN,
    LINE_UP,
    # PAGE_BOTTOM (Shift + G) goes before PAGE_TOP (G).
    PAGE_BOTTOM,
    PAGE_TOP,
]
