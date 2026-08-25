@icon("res://general/icons/boss_orchestrator.svg")
class_name BossBattleOrchestrator extends Node

signal battle_started
signal battle_ended
signal boss_reward_collected

@export var boss_name : String = "Boss Name"
@export var boss : Node
@export var trigger_area : Area2D
@export var boss_tilemaps : Array[ TileMapLayer ]
@export var reward : Node2D

@export_category("Boss Music")
@export var boss_track : AudioStream
@export var post_boss_track : AudioStream

@export_category("Camera Bounds")
@export var boss_level_bounds : LevelBounds
@export var original_level_bounds : LevelBounds

func _ready() -> void:
	if boss:
		boss.process_mode = Node.PROCESS_MODE_DISABLED
	
	for t in boss_tilemaps:
		t.enabled = false
	
	if trigger_area:
		trigger_area.set_collision_mask_value( 5, true )
		trigger_area.set_collision_mask_value( 1, false )
		trigger_area.set_collision_layer_value( 1, false )
		trigger_area.body_entered.connect( _on_body_entered )
	
	if reward:
		reward.process_mode = Node.PROCESS_MODE_DISABLED
		reward.visible = false
	
	if SaveManager.persistent_data.get_or_add( unique_name(), "" ) == "defeated":
		queue_free()
	pass


func start_boss_battle() -> void:
	battle_started.emit()
	PlayerHud.in_boss_battle = true
	
	if boss_level_bounds:
		boss_level_bounds.set_camera_bounds()
	
	for t in boss_tilemaps:
		t.enabled = true
	
	Audio.play_music( boss_track )
	PlayerHud.show_boss_hp( boss_name )
	
	if boss:
		boss.process_mode = Node.PROCESS_MODE_INHERIT
		boss.tree_exiting.connect( end_boss_battle )
		
		if boss is Enemy:
			boss.was_hit.connect( _on_boss_enemy_hit )
		else:
			for c in boss.get_children():
				if c is DamageArea:
					c.damage_taken.connect( _on_boss_enemy_hit )
	pass


func end_boss_battle() -> void:
	battle_ended.emit()
	SaveManager.persistent_data[ unique_name() ] = "defeated"
	
	Audio.play_music( post_boss_track )
	
	PlayerHud.hide_boss_hp()
	PlayerHud.in_boss_battle = false
	
	await deliver_reward()
	
	if original_level_bounds:
		original_level_bounds.set_camera_bounds()
	
	for t in boss_tilemaps:
		t.enabled = false
	
	pass


func deliver_reward() -> bool:
	if not reward:
		return false
	
	if reward:
		reward.process_mode = Node.PROCESS_MODE_INHERIT
		reward.visible = true
	
	await reward.tree_exiting
	boss_reward_collected.emit()
	return true


func _on_body_entered( body : Node2D ) -> void:
	if body is Player:
		start_boss_battle()
		trigger_area.body_entered.disconnect( _on_body_entered )
	pass


func unique_name() -> String:
	var u_name : String = ResourceUID.path_to_uid( owner.scene_file_path )
	u_name += "/" + get_parent().name + "/" + name
	return u_name


func _on_boss_enemy_hit( _a : AttackArea ) -> void:
	if boss is Enemy:
		PlayerHud.update_boss_hp( boss.blackboard.health, boss.health )
	elif _a:
		PlayerHud.update_boss_hp( boss.hp, boss.max_hp )
	pass
