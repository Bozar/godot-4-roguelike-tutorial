class_name CustomLineEdit
extends LineEdit


const FONT_COLOR_SETTINGS: Array = [
        ["font_color", true],
        ["font_placeholder_color", false],
]


var _font: Font = preload("res://resource/FiraCode-Regular.ttf")


func _ready() -> void:
    text = ""
    placeholder_text = ""


func init_gui() -> void:
    pass


func _set_font() -> void:
    var palette: Dictionary = TransferData.palette
    var color_name: String
    var is_light_color: bool

    for i: Array in FONT_COLOR_SETTINGS:
        color_name = i[0]
        is_light_color = i[1]
        add_theme_font_override("font", _font)
        add_theme_font_size_override("font_size", 24)
        add_theme_color_override(color_name, Palette.get_color(palette,
                MainTag.GUI_TEXT, is_light_color))
