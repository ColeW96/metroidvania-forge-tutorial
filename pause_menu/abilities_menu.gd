extends Control

@onready var abilities_tab: TabContainer = %AbilitiesTab


func _ready() -> void:
	var player : Player = get_tree().get_first_node_in_group( "Player" )
	if player:
		abilities_tab.set_tab_hidden( 0, not player.ledge_grab )
		abilities_tab.set_tab_hidden( 1, not player.double_jump )
		abilities_tab.set_tab_hidden( 2, not player.dash )
		abilities_tab.set_tab_hidden( 3, not player.ground_slam )
		abilities_tab.set_tab_hidden( 4, not player.morph_roll )
	pass
