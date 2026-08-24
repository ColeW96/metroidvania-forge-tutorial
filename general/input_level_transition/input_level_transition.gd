@tool
@icon( "res://general/icons/level_transition.svg" )
class_name InputLevelTransition extends Node2D

@export_file( "*.tscn" ) var target_level : String = ""
@export var target_area_name : String = "InputLevelTransition"

var player_in_area : bool = false

@onready var area_2d: Area2D = $Area2D


func _ready() -> void:
	if Engine.is_editor_hint():
		return
	SceneManager.new_scene_ready.connect( _on_new_scene_ready )
	SceneManager.load_scene_finished.connect( _on_load_scene_finished )
	pass


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("up") and player_in_area:
		get_viewport().set_input_as_handled()
		SceneManager.transition_scene( target_level, target_area_name, Vector2(0, 6), "up" )



func _on_player_entered( _n : Node2D ) -> void:
	Messages.input_hint_changed.emit("up")
	player_in_area = true
	pass


func _on_player_exited( _n : Node2D ) -> void:
	Messages.input_hint_changed.emit("")
	player_in_area = false
	pass


func _on_new_scene_ready( target_name : String, offset : Vector2 ) -> void:
	if target_name == name:
		var player : Node = get_tree().get_first_node_in_group( "Player" )
		player.global_position = global_position + offset
	pass


func _on_load_scene_finished() -> void:
	area_2d.monitoring = false
	area_2d.body_entered.connect( _on_player_entered )
	area_2d.body_exited.connect( _on_player_exited )
	await get_tree().physics_frame
	await get_tree().physics_frame
	area_2d.monitoring = true
	pass
