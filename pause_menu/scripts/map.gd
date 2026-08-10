class_name Map extends Control

func _ready() -> void:
	for c in get_children():
		if c is MapNode:
			if c.has_node("PowerupMapNode"):
				if SaveManager.persistent_data.get( _get_path( c.linked_scene ) ) == "acquired":
					var n : Node2D = c.get_node("PowerupMapNode")
					if n:
						n.visible = false
	pass


func _get_path( scene_uid : String ) -> String:
	var scene = load(scene_uid) as PackedScene
	var instance = scene.instantiate()
	
	var scene_path = instance.scene_file_path
	var scene_name = instance.name
	instance.queue_free()
	return scene_path + "/" + scene_name +  "/Powerup"
