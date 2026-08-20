class_name AbilityMessage extends CanvasLayer

var descriptions : Dictionary = {
	"double_jump" : "Perform a second jump mid-air. Useful for reaching new heights!",
	"dash" : "Dash forward to avoid harm. Can be used in the air or on the ground!",
	"ground_slam" : "Launch straight down dealing damage and destroying certain objects!",
	"morph_roll" : "Assume a spherical form to traverse new paths!",
	"ledge_grab" : "Hang on ledges and gaps in walls to ascend upwards!"
}

@onready var ability_name_label: Label = %AbilityNameLabel
@onready var ability_desc_label: Label = %AbilityDescLabel

func _ready() -> void:
	get_tree().paused = true
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("attack"):
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
