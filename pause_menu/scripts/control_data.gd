class_name ControlData extends Resource

enum ControlType {LABEL, GUI_INPUT_HINT}

@export var type : ControlType = ControlType.LABEL

@export_group("Label Settings")
@export var label_text : String = ""
@export var font_size : int = 8

@export_group("GuiInputHint Settings")
@export var hint_type : GuiInputHints.Hint = GuiInputHints.Hint.ACTION
