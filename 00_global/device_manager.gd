# DeviceManager
extends Node

signal device_changed

var controller_type : String = "keyboard"

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton or event is InputEventKey:
		controller_type = "xbox"
	elif event is InputEventJoypadButton:
		get_controller_type( event.device )
	device_changed.emit()
	pass


func get_controller_type( device_id : int ) -> void:
	var n : String = Input.get_joy_name( device_id ).to_lower()
	
	if "xbox" in n:
		controller_type = "xbox"
	elif "nintendo" in n or "switch" in n:
		controller_type = "switch"
	else:
		controller_type = "playstation"
		
	set_process_input( false )
	pass
