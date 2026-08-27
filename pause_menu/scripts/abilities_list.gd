# AbilitiesList
extends Node

@onready var ability_ledge_grab: Button = %AbilityLedgeGrab
@onready var ability_double_jump: Button = %AbilityDoubleJump
@onready var ability_dash: Button = %AbilityDash
@onready var ability_ground_slam: Button = %AbilityGroundSlam
@onready var ability_morph_roll: Button = %AbilityMorphRoll



func _ready() -> void:
	var player : Player = get_tree().get_first_node_in_group("Player")
	ability_ledge_grab.visible = player.ledge_grab
	ability_dash.visible = player.dash
	ability_double_jump.visible = player.double_jump
	ability_ground_slam.visible = player.ground_slam
	ability_morph_roll.visible = player.morph_roll
	pass
