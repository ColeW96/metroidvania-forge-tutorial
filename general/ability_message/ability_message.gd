class_name AbilityMessage extends CanvasLayer

const GUI_INPUT_HINTS = preload("uid://doln5e7j65ibw")

const CONTROLLERS : Dictionary = {
	"keyboard" : 273,
	"playstation" : 26,
	"xbox" : 91,
	"switch" : 260
}

var descriptions : Dictionary = {
	"double_jump" : "Perform a second jump mid-air. Useful for reaching new heights!",
	"dash" : "Dash forward to avoid harm. Can be used in the air or on the ground!",
	"ground_slam" : "Launch straight down dealing damage and destroying certain objects!",
	"morph_roll" : "Assume a spherical form to traverse new paths!",
	"ledge_grab" : "Hang on ledges and gaps in walls to ascend upwards!"
}

@onready var ability_name_label: Label = %AbilityNameLabel
@onready var ability_desc_label: Label = %AbilityDescLabel
@onready var action_container: HBoxContainer = %ActionContainer
@onready var note_container: HBoxContainer = %NoteContainer
@onready var action_label: Label = %ActionLabel

func _ready() -> void:
	get_tree().paused = true
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot"):
		get_viewport().set_input_as_handled()
		get_tree().paused = false
		queue_free()
	pass


func set_ability_message_text( ability_name : String ) -> void:
	match ability_name:
		"double_jump":
			ability_name_label.text = "Double Jump"
			ability_desc_label.text = descriptions.get(ability_name)
		"dash":
			ability_name_label.text = "Dash"
			ability_desc_label.text = descriptions.get(ability_name)
		"ground_slam":
			ability_name_label.text = "Ground Slam"
			ability_desc_label.text = descriptions.get(ability_name)
		"morph_roll":
			ability_name_label.text = "Morph Ball"
			ability_desc_label.text = descriptions.get(ability_name)
		"ledge_grab":
			ability_name_label.text = "Ledge Grab"
			ability_desc_label.text = descriptions.get(ability_name)
	pass


func set_action( ability_name : String ) -> void:
	match ability_name:
		"double_jump":
			set_double_jump()
		"dash":
			set_dash()
		"ground_slam":
			set_ground_slam()
		"morph_roll":
			set_morph_roll()
		"ledge_grab":
			set_ledge_grab()
	pass


func set_double_jump() -> void:
	var input_hint : GuiInputHints = GUI_INPUT_HINTS.instantiate()
	input_hint.hint = input_hint.Hint.JUMP
	action_container.add_child(input_hint)
	
	var label : Label = Label.new()
	label.text = "->"
	label.add_theme_font_size_override( "font_size", 8 )
	label.add_theme_color_override( "font_shadow_color", Color(0,0,0) )
	action_container.add_child(label)
	
	var input_hint2 : GuiInputHints = GUI_INPUT_HINTS.instantiate()
	input_hint2.hint = input_hint.Hint.JUMP
	action_container.add_child( input_hint2 )
	pass


func set_dash() -> void:
	var input_hint : GuiInputHints = GUI_INPUT_HINTS.instantiate()
	input_hint.hint = input_hint.Hint.DASH
	action_container.add_child(input_hint)
	pass


func set_ground_slam() -> void:
	var input_hint : GuiInputHints = GUI_INPUT_HINTS.instantiate()
	input_hint.hint = input_hint.Hint.DOWN
	action_container.add_child(input_hint)
	
	var label : Label = Label.new()
	label.text = "+"
	label.add_theme_font_size_override( "font_size", 8 )
	label.add_theme_color_override( "font_shadow_color", Color(0,0,0) )
	action_container.add_child(label)
	
	var input_hint2 : GuiInputHints = GUI_INPUT_HINTS.instantiate()
	input_hint2.hint = input_hint.Hint.ATTACK
	action_container.add_child( input_hint2 )
	pass


func set_morph_roll() -> void:
	var input_hint : GuiInputHints = GUI_INPUT_HINTS.instantiate()
	input_hint.hint = input_hint.Hint.MORPH
	action_container.add_child(input_hint)
	pass


func set_ledge_grab() -> void:
	action_label.text = ""
	var label : Label = Label.new()
	label.text = "Note: Release"
	label.add_theme_font_size_override( "font_size", 8 )
	label.add_theme_color_override( "font_shadow_color", Color(0,0,0) )
	note_container.add_child(label)
	
	var input_hint : GuiInputHints = GUI_INPUT_HINTS.instantiate()
	input_hint.hint = input_hint.Hint.JUMP
	note_container.add_child(input_hint)
	
	var label2 : Label = Label.new()
	label2.text = "to grab a ledge."
	label2.add_theme_font_size_override( "font_size", 8 )
	label2.add_theme_color_override( "font_shadow_color", Color(0,0,0) )
	note_container.add_child(label2)
	pass
