class_name NPBHDecisionEngine
extends DecisionEngine

@export var idle_state : EnemyState

@onready var es_death: ESDeath = %ESDeath
@onready var es_attack: ESAttack = %ESAttack
@onready var es_chase: ESChase = %ESChase
@onready var es_dash_attack: ESNPBHDashAttack = %ESNPBHDashAttack

var regular_attacks_executed : float = 0.0

func _ready() -> void:
	await super() # Maintains important setup code & timing
	# Implement your own scripts here
	pass


# All the conditions for making decisions go in this function
func decide() -> EnemyState:
	if blackboard.damage_source:
		if blackboard.health <= 0:
			return es_death
	
	if current_state is ESDeath or not blackboard.can_decide:
		return null
	
	if blackboard.target:
		if regular_attacks_executed > 3:
			if es_dash_attack.can_attack():
				regular_attacks_executed = 0
				return es_dash_attack
		
		if es_attack.can_attack():
			regular_attacks_executed += 1
			return es_attack
		
		if blackboard.distance_to_target > es_attack.attack_range:
			return es_chase
	
	return idle_state
