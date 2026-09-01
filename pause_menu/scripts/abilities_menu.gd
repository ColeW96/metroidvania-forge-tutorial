# AbilitiesMenu
extends Control

@onready var abilities_tab: TabContainer = %AbilitiesTab
@onready var skill_tokens_label: Label = %SkillTokensLabel
@onready var skill_tokens_container: HBoxContainer = %SkillTokensContainer


func _ready() -> void:
	skill_tokens_container.visible = false
	var player : Player = get_tree().get_first_node_in_group( "Player" )
	if player:
		abilities_tab.set_tab_hidden( 0, not player.ledge_grab )
		abilities_tab.set_tab_hidden( 1, not player.double_jump )
		abilities_tab.set_tab_hidden( 2, not player.dash )
		abilities_tab.set_tab_hidden( 3, not player.ground_slam )
		abilities_tab.set_tab_hidden( 4, not player.morph_roll )
	
	if not abilities_tab.is_tab_hidden(0):
		abilities_tab.current_tab = 0
	
	for c in abilities_tab.get_children():
		if c.visible == true:
			skill_tokens_container.visible = true
	
	skill_tokens_label.text = str(player.skill_tokens)
	pass
