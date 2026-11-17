extends Node

@export var hp : float = 30.0
var max_hp : float

@onready var boss_battle_orchestrator: BossBattleOrchestrator = $".."
@onready var damage_area: DamageArea = $"../DamageArea"
@onready var exit_blocker: StaticBody2D = %ExitBlocker


func _ready() -> void:
	max_hp = hp
	damage_area.damage_taken.connect( _on_damage_taken )
	pass


func _on_damage_taken( a : AttackArea ) -> void:
	hp -= a.damage
	
	if hp <= 0:
		damage_area.queue_free()
		# TEMP CODE
		boss_battle_orchestrator.end_boss_battle()
		exit_blocker.queue_free()
		pass
	
	PlayerHud.update_boss_hp( hp, max_hp )
	pass
