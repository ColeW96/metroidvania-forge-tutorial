@tool
class_name Powerup extends Node2D

enum Type { HEALTH }

@export var amount : float = 10
@export var type : Type = Type.HEALTH :
	set( value ):
		type = value
		_set_animation()

@onready var powerup_anim: AnimationPlayer = %PowerupAnim
@onready var area_2d: Area2D = $Area2D


func _ready() -> void:
	_set_animation()
	
	if Engine.is_editor_hint():
		return
	
	if SaveManager.persistent_data.get_or_add( _get_path(), "" ) == "acquired":
		queue_free()
		return
	
	area_2d.body_entered.connect( _on_body_entered )
	pass


func _on_body_entered( n : Node2D ) -> void:
	SaveManager.persistent_data[ _get_path() ] = "acquired"
	match type:
		Type.HEALTH:
			n.max_hp += amount
			n.hp = n.max_hp
	area_2d.body_entered.disconnect( _on_body_entered )
	queue_free()
	pass


func _set_animation() -> void:
	if not powerup_anim:
		powerup_anim = %PowerupAnim
	powerup_anim.play( get_powerup_name() )
	pass


func get_powerup_name() -> String:
	match type:
		Type.HEALTH:
			return "health_powerup"
	return ""

func _get_path() -> String:
	return get_tree().current_scene.scene_file_path + "/" + get_parent().name + "/" + name
