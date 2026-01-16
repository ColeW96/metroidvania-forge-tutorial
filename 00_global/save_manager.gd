# SaveManager
extends Node

const CONFIG_FILE_PATH = "user://settings.cfg"

# Forest level 01
const DEFAULT_SCENE_PATH : String = "uid://cuhy61b0drxbf"
const SLOTS : Array[ String ] = [
	"save_01", "save_02", "save_03"
]


var save_file_path : String = "user://"
var current_slot : int = 0
var save_data : Dictionary
var discovered_areas : Array = []
var persistent_data : Dictionary = {}


func _ready() -> void:
	load_configuration()
	SceneManager.scene_entered.connect( _on_scene_entered )
	pass


func _unhandled_key_input( event: InputEvent ) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_F5:
			save_game()
		elif event.keycode == KEY_F7:
			load_game( current_slot )
		elif event.keycode == KEY_1:
			current_slot = 0
		elif event.keycode == KEY_2:
			current_slot = 1
		elif event.keycode == KEY_3:
			current_slot = 2
	pass


func create_new_game_save( slot : int ) -> void:
	current_slot = slot
	discovered_areas.clear()
	persistent_data.clear()
	discovered_areas.append( DEFAULT_SCENE_PATH )
	save_data = {
		"scene_path" : DEFAULT_SCENE_PATH,
		"x" : 22,
		"y" : 229,
		"hp" : 20,
		"max_hp" : 20,
		"dash" : false,
		"double_jump" : false,
		"ground_slam" : false,
		"morph_roll" : false,
		"discovered_areas" : discovered_areas,
		"persistent_data" : persistent_data,
	}
	# save data
	write_to_save_file()
	load_game( slot )
	pass


func save_game() -> void:
	var player : Player = get_tree().get_first_node_in_group( "Player" )
	save_data = {
		"scene_path" : SceneManager.current_scene_UID,
		"x" : player.global_position.x,
		"y" : player.global_position.y,
		"hp" : player.hp,
		"max_hp" : player.max_hp,
		"dash" : player.dash,
		"double_jump" : player.double_jump,
		"ground_slam" : player.ground_slam,
		"morph_roll" : player.morph_roll,
		"discovered_areas" : discovered_areas,
		"persistent_data" : persistent_data,
	}
	write_to_save_file()
	pass


func load_game( slot : int ) -> void:
	if not FileAccess.file_exists( get_file_name( current_slot ) ):
		return
	
	current_slot = slot
	
	var save_file = FileAccess.open( get_file_name( current_slot ), FileAccess.READ )
	save_data = JSON.parse_string( save_file.get_line() )
	
	persistent_data = save_data.get( "persistent_data", {} )
	discovered_areas = save_data.get( "discovered_areas", [] )
	
	var scene_path : String = save_data.get( "scene_path", DEFAULT_SCENE_PATH )
	SceneManager.transition_scene( scene_path, "", Vector2.ZERO, "up" )
	
	await SceneManager.new_scene_ready
	setup_player()
	pass


func setup_player() -> void:
	var player : Player = null
	while not player:
		player = get_tree().get_first_node_in_group( "Player" )
		await get_tree().process_frame
	
	player.max_hp = save_data.get( "max_hp", 20 )
	player.hp = save_data.get( "hp", 20 )
	
	player.dash = save_data.get( "dash", false )
	player.double_jump = save_data.get( "double_jump", false )
	player.ground_slam = save_data.get( "ground_slam", false )
	player.morph_roll = save_data.get( "morph_roll", false )
	
	player.global_position = Vector2(
		save_data.get( "x", 0 ),
		save_data.get( "y", 0 )
	)
	pass


func get_file_name( slot : int ) -> String:
	return save_file_path + SLOTS[ slot ] + ".sav"


func write_to_save_file() -> void:
	var save_file = FileAccess.open( get_file_name( current_slot ), FileAccess.WRITE )
	save_file.store_line( JSON.stringify( save_data ) )
	save_file.close()
	pass


func save_file_exists( slot : int ) -> bool:
	return FileAccess.file_exists( get_file_name( slot ) )


func is_area_discovered( scene_uid : String ) -> bool:
	return discovered_areas.has( scene_uid )


func _on_scene_entered( scene_uid : String ) -> void:
	if discovered_areas.has( scene_uid ):
		return
	else:
		discovered_areas.append( scene_uid )
	pass


#region /// Configuration functions

func save_configuration() -> void:
	var config := ConfigFile.new()
	config.set_value( "audio", "music", AudioServer.get_bus_volume_linear( 2 ) )
	config.set_value( "audio", "sfx", AudioServer.get_bus_volume_linear( 3 ) )
	config.set_value( "audio", "ui", AudioServer.get_bus_volume_linear( 4 ) )
	config.save( CONFIG_FILE_PATH )
	pass

func load_configuration() -> void:
	var config := ConfigFile.new()
	var err = config.load( CONFIG_FILE_PATH )
	
	if err != OK:
		AudioServer.set_bus_volume_linear( 2, 0.8 )
		AudioServer.set_bus_volume_linear( 3, 1.0 )
		AudioServer.set_bus_volume_linear( 4, 1.0 )
		save_configuration()
		return
	
	AudioServer.set_bus_volume_linear( 2, config.get_value( "audio", "music", 0.8 ) )
	AudioServer.set_bus_volume_linear( 3, config.get_value( "audio", "sfx", 1.0 ) )
	AudioServer.set_bus_volume_linear( 4, config.get_value( "audio", "ui", 1.0 ) )
	pass
	
#endregion
