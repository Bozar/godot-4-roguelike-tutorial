class_name StatusLabel
extends CustomLabel


var _ref_PcAction: PcAction


func _ready() -> void:
    _set_font(true)


func init_gui() -> void:
    update_gui()


func update_gui() -> void:
    text = "%s" % _get_ammo()


func _get_ammo() -> String:
    return "Ammo: %d" % _ref_PcAction.ammo
