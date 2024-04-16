class_name FootnoteLabel
extends CustomLabel


func _ready() -> void:
    _set_font(false)


func init_gui() -> void:
    text = "%s\n%s\n%s\n%s" % [
        _get_version(), _get_help(), _get_debug(), _get_seed()
    ]


func _get_version() -> String:
    return "1.0.0"


func _get_help() -> String:
    return "Help: C"


func _get_debug() -> String:
    return "Debug: V"


func _get_seed() -> String:
    return "123-456-7890"
