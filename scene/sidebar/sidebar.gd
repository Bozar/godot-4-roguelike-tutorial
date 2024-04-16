class_name Sidebar
extends CustomMarginContainer


var _ref_PcAction: PcAction

@onready var _ref_FootnoteLabel: FootnoteLabel = $SidebarVBox/FootnoteLabel
@onready var _ref_StatusLabel: StatusLabel = $SidebarVBox/StatusLabel


func init_gui() -> void:
    _ref_StatusLabel._ref_PcAction = _ref_PcAction

    _ref_FootnoteLabel.init_gui()
    _ref_StatusLabel.init_gui()


func update_gui() -> void:
    _ref_StatusLabel.update_gui()


func _on_Schedule_turn_started(sprite: Sprite2D) -> void:
    if not sprite.is_in_group(SubTag.PC):
        return
    update_gui()
