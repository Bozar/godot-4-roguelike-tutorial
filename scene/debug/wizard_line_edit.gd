class_name WizardLineEdit
extends CustomLineEdit


func init_gui() -> void:
    text = "%s" % TransferData.wizard_mode
    placeholder_text = "DEFAULT: FALSE OR 0"
    _set_font()
