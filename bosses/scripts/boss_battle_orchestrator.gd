@icon("res://general/icons/boss_orchestrator.svg")
class_name BossBattleOrchestrator extends Node

signal battle_started
signal battle_ended
signal boss_reward_collected

@export var boss : Node
@export var trigger_area : Area2D

@export_category("Boss Music")
@export var boss_track : AudioStream
@export var post_boss_track : AudioStream

@export_category("Camera Bounds")
@export var boss_level_bounds : LevelBounds
@export var original_level_bounds : LevelBounds

func _ready() -> void:
	if boss:
		boss.process_mode = Node.PROCESS_MODE_DISABLED
	
	if trigger_area:
		trigger_area.set_collision_mask_value( 5, true )
		trigger_area.set_collision_mask_value( 1, false )
		trigger_area.set_collision_layer_value( 1, false )
		trigger_area.body_entered.connect( _on_body_entered )
	pass


func start_boss_battle() -> void:
	battle_started.emit()
	
	Audio.play_music( boss_track )
	if boss:
		boss.process_mode = Node.PROCESS_MODE_INHERIT
		boss.tree_exiting.connect( end_boss_battle )
	pass


func end_boss_battle() -> void:
	battle_ended.emit()
	print("Boss battle ended")
	
	Audio.play_music( post_boss_track )
	pass


func _on_body_entered( body : Node2D ) -> void:
	if body is Player:
		start_boss_battle()
		trigger_area.body_entered.disconnect( _on_body_entered )
	pass
