@icon( "res://general/icons/player_spawn.svg" )
class_name PlayerSpawn extends Node2D



func _ready() -> void:
	visible = false
	await get_tree().process_frame
	
	# check to see if we already have a player
	if get_tree().get_first_node_in_group( "Player" ):
		# yes, do nothing
		return
		
	# Instantiate a new isntance of player in the scene
	var player : Player = load( "res://player/player.tscn" ).instantiate()
	get_tree().root.add_child( player )
	
	# position the player scene in the level
	player.global_position = self.global_position
	pass
