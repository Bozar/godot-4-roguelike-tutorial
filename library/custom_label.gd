class_name CustomLabel
extends Label


var _font: Font = preload("res://resource/FiraCode-Regular.ttf")


func init_gui() -> void:
    pass


func update_gui() -> void:
    pass


func _set_font(is_light_color: bool) -> void:
    var palette: Dictionary = TransferData.palette

    add_theme_font_override("font", _font)
    add_theme_font_size_override("font_size", 24)
    add_theme_color_override("font_color", Palette.get_color(palette,
            MainTag.GUI_TEXT, is_light_color))


func _set_autowrap(minimum_size: Vector2 = Vector2(720, 0)) -> void:
    autowrap_mode = TextServer.AutowrapMode.AUTOWRAP_WORD_SMART
    custom_minimum_size = minimum_size
