@tool
class_name SlamBreakable extends StaticBody2D


func _ready() -> void:
	if Engine.is_editor_hint():
		return
	
	if SaveManager.persistent_data.get_or_add( _get_path(), "" ) == "destroyed":
		queue_free()
		return
	
	pass


func _get_path() -> String:
	return get_tree().current_scene.scene_file_path + "/" + get_parent().name + "/" + name


func save_persistence() -> void:
	SaveManager.persistent_data[ _get_path() ] = "destroyed"
	pass
