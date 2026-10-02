class_name EyeSwitch extends Node2D

signal activated

var is_open : bool = false

@onready var damage_area: DamageArea = $DamageArea


func _ready() -> void:
	if SaveManager.persistent_data.get_or_add( unique_name(), "closed" ) == "open":
		set_open()
	else:
		damage_area.damage_taken.connect( _on_damage_taken )


func set_open() -> void:
	is_open = true
	damage_area.queue_free()
	pass


func unique_name() -> String:
	var u_name : String = ResourceUID.path_to_uid( owner.scene_file_path )
	u_name += "/" + get_parent().name + "/" + name
	return u_name


func _on_damage_taken( _a : AttackArea ) -> void:
	SaveManager.persistent_data[ unique_name() ] = "open"
	activated.emit()
	set_open()
	pass
