@icon("res://general/icons/boss_orchestrator.svg")
class_name BossBattleOrchestrator extends Node

signal battle_started
signal battle_ended
signal boss_reward_collected

@export var boss : Node
@export var trigger_area : Area2D


func _ready() -> void:
	if boss:
		boss.process_mode = Node.PROCESS_MODE_DISABLED
	
	pass
