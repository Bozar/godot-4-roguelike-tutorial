class_name DebugScreen
extends CustomMarginContainer


const GUI_NODES: Array = [
    "DebugVBox/TitleLabel",
    "DebugVBox/SettingGrid/SeedLabel",
    "DebugVBox/SettingGrid/WizardLabel",
    "DebugVBox/SettingGrid/MapLabel",
    "DebugVBox/SettingGrid/SeedLineEdit",
    "DebugVBox/SettingGrid/WizardLineEdit",
    "DebugVBox/SettingGrid/MapLineEdit",
]

const TRUE: String = "true"
const FALSE: String = "false"
const MAX_INT: int = 2 ** 32 - 1


@onready var _ref_SeedLineEdit: CustomLineEdit = \
        $DebugVBox/SettingGrid/SeedLineEdit
@onready var _ref_WizardLineEdit: CustomLineEdit = \
        $DebugVBox/SettingGrid/WizardLineEdit
@onready var _ref_MapLineEdit: CustomLineEdit = \
        $DebugVBox/SettingGrid/MapLineEdit


func _ready() -> void:
    visible = false
    size = Vector2(800, 600)
    add_theme_constant_override("margin_left", 60)
    add_theme_constant_override("margin_top", 40)
    add_theme_constant_override("margin_right", 60)
    add_theme_constant_override("margin_bottom", 60)

    $DebugVBox.add_theme_constant_override("separation", 40)

    $DebugVBox/SettingGrid.columns = 2
    $DebugVBox/SettingGrid.add_theme_constant_override("h_separation", 10)
    $DebugVBox/SettingGrid.add_theme_constant_override("v_separation", 10)

    $DebugVBox/SettingGrid/SeedLineEdit.size_flags_horizontal = SIZE_EXPAND_FILL


func init_gui() -> void:
    for i: String in GUI_NODES:
        get_node(i).init_gui()


# NOTE: Delete `ui_cancel` key in `Input Map`.
func _on_PlayerInput_action_pressed(input_tag: StringName) -> void:
    match input_tag:
        InputTag.CLOSE_MENU:
            visible = false
        InputTag.OPEN_DEBUG_MENU:
            _ref_SeedLineEdit.grab_focus()
            visible = true
        InputTag.REPLAY_GAME:
            _set_transfer_data(input_tag)
        InputTag.RESTART_GAME:
            _set_transfer_data(input_tag)
        InputTag.START_NEW_GAME:
            _set_transfer_data(input_tag)


func _set_transfer_data(input_tag: StringName) -> void:
    if input_tag != InputTag.REPLAY_GAME:
        TransferData.set_rng_seed(_get_int(_ref_SeedLineEdit.text))
    TransferData.set_wizard_mode(_get_bool(_ref_WizardLineEdit.text))
    TransferData.set_show_full_map(_get_bool(_ref_MapLineEdit.text))


func _get_int(line_edit_text: String) -> int:
    var text_to_int: int = int(line_edit_text)

    if text_to_int > MAX_INT:
        return 0
    return text_to_int


func _get_bool(line_edit_text: String) -> bool:
    var text: String = line_edit_text.strip_edges().to_lower()

    match text:
        TRUE:
            return true
        FALSE:
            return false
        _:
            return bool(int(text))
