@tool
@icon( "res://general/icons/ability_pickup.svg" )
class_name AbilityPickup extends Node2D

enum Type { DOUBLE_JUMP, DASH, GROUND_SLAM, MORPH_ROLL }
@export var type : Type = Type.DOUBLE_JUMP :
	set( value ):
		type = value
		_set_animation()

@onready var ability_anim: AnimationPlayer = %AbilityAnim
@onready var orb_anim: AnimationPlayer = %OrbAnim
@onready var breakable: Breakable = $Breakable
@onready var orb_sprite: Sprite2D = %OrbSprite



func _ready() -> void:
	_set_animation()
	
	if Engine.is_editor_hint():
		return
	
	if SaveManager.persistent_data.get_or_add( get_ability_name(), "" ) == "acquired":
		queue_free()
		return
	
	breakable.destroyed.connect( _on_destroyed )
	breakable.damage_taken.connect( _on_damage_taken )
	pass


func _on_damage_taken() -> void:
	orb_sprite.frame += 1
	pass


func _on_destroyed() -> void:
	SaveManager.persistent_data[ get_ability_name() ] = "acquired"
	_reward_ability()
	orb_anim.play("destroy")
	await orb_anim.animation_finished
	queue_free()
	pass


func _reward_ability() -> void:
	var player : Player = get_tree().get_first_node_in_group("Player")
	match type:
		Type.DOUBLE_JUMP:
			player.double_jump = true
		Type.DASH:
			player.dash = true
		Type.GROUND_SLAM:
			player.ground_slam = true
		Type.MORPH_ROLL:
			player.morph_roll = true
	pass


func _set_animation() -> void:
	if not ability_anim:
		ability_anim = %AbilityAnim
	ability_anim.play( get_ability_name() )
	pass


func get_ability_name() -> String:
	match type:
		Type.DOUBLE_JUMP:
			return "double_jump"
		Type.DASH:
			return "dash"
		Type.GROUND_SLAM:
			return "ground_slam"
		Type.MORPH_ROLL:
			return "morph_roll"
	return ""
