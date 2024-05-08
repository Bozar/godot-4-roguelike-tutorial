class_name MapLineEdit
extends CustomLineEdit


func init_gui() -> void:
    text = "%s" % TransferData.show_full_map
    placeholder_text = "DEFAULT: FALSE OR 0"
    _set_font()
