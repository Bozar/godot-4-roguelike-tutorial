class_name FootnoteLabel
extends CustomLabel


var _ref_RandomNumber: RandomNumber


func init_gui() -> void:
    _set_font(false)
    text = "%s\n%s\n%s\n%s" % [
        _get_version(), _get_help(), _get_debug(), _get_seed()
    ]


func _get_version() -> String:
    var wizard: String = "+" if TransferData.wizard_mode else ""
    var version: String = "1.0.0"

    return "%s%s" % [wizard, version]


func _get_help() -> String:
    return "Help: C"


func _get_debug() -> String:
    return "Debug: V"


func _get_seed() -> String:
    var str_seed: String = "%d" % _ref_RandomNumber.get_seed()
    var seed_len: int = str_seed.length()
    var head: String = str_seed.substr(0, 3)
    var body: String = ("-" + str_seed.substr(3, 3)) if (seed_len > 3) else ""
    var tail: String = ("-" + str_seed.substr(6)) if (seed_len > 6) else ""

    return "%s%s%s" % [head, body, tail]
