# SceneManager
extends CanvasLayer

signal load_scene_started
signal new_scene_ready( target_name : String, offset : Vector2 )
signal load_scene_finished
signal scene_entered( uid : String )

@onready var fade: Control = $Fade

var current_scene_UID : String


func _ready() -> void:
	fade.visible = false
	await get_tree().process_frame
	load_scene_finished.emit()
	var current_scene : String = get_tree().current_scene.scene_file_path
	current_scene_UID = ResourceUID.path_to_uid( current_scene )
	scene_entered.emit( current_scene_UID )
	pass



func transition_scene( new_scene : String, target_area : String, player_offset : Vector2, dir : String ) -> void:
	
	get_tree().paused = true
	
	var fade_pos : Vector2 = get_fade_position( dir )
	
	fade.visible = true
	
	load_scene_started.emit()
	
	await fade_screen( fade_pos, Vector2.ZERO )
	
	get_tree().change_scene_to_file( new_scene )
	current_scene_UID = ResourceUID.path_to_uid( new_scene )
	scene_entered.emit( current_scene_UID )
	
	await get_tree().scene_changed
	
	new_scene_ready.emit( target_area, player_offset )
	
	await get_tree().process_frame
	await fade_screen( Vector2.ZERO, -fade_pos )
	
	fade.visible = false
	
	get_tree().paused = false
	
	load_scene_finished.emit()
	pass


func fade_screen( from : Vector2, to : Vector2 ) -> Signal:
	fade.position = from
	var tween : Tween = create_tween()
	tween.tween_property( fade, "position", to, 0.2 )
	return tween.finished


func get_fade_position( dir : String ) -> Vector2:
	var pos : Vector2 = Vector2( 480 * 2, 270 * 2 )
	
	match  dir:
		"left":
			pos *= Vector2( -1, 0 )
		"right":
			pos *= Vector2( 1, 0 )
		"up":
			pos *= Vector2( 0, -1 )
		"down":
			pos *= Vector2( 0, 1 )
	return pos
