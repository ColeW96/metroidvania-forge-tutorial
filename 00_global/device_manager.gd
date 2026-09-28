# DeviceManager
extends Node

signal device_changed

var controller_type : String = "keyboard"

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	pass

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton or event is InputEventKey:
		controller_type = "keyboard"
	elif event is InputEventJoypadButton:
		get_controller_type( event.device )
	device_changed.emit()
	pass


func get_controller_type( device_id : int ) -> void:
	var device_name : String = Input.get_joy_name( device_id ).to_lower()
	
	if "xbox" in device_name:
		controller_type = "xbox"
	elif switch_name_in_device_name(device_name):
		controller_type = "switch"
	else:
		controller_type = "playstation"
	#set_process_input( false )
	pass


func switch_name_in_device_name( device_name : String ) -> bool:
	var switch_names : Array[String] = [ "nintendo", "switch", "nsw" ]
	for n in switch_names:
		if n in device_name:
			return true
	return false
