class_name AbilityMessage extends CanvasLayer

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
@onready var texture_rect: TextureRect = %TextureRect

func _ready() -> void:
	get_tree().paused = true
	set_close_texture()
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


func set_close_texture() -> void:
	var p : Player = get_tree().get_first_node_in_group("Player")
	var input_hints : InputHints
	for c in p.get_children():
		if c is InputHints:
			input_hints = c
			break
	
	var controller : String = input_hints.controller_type
	controller = "playstation"
	var atlas_texture : AtlasTexture = texture_rect.texture as AtlasTexture
	if atlas_texture:
		atlas_texture.region = Rect2( get_region_x( controller ), 0, 13, 0 )
	pass


func get_region_x( controller_name : String ) -> int:
	var x : int = CONTROLLERS.get(controller_name, 39)
	return x
