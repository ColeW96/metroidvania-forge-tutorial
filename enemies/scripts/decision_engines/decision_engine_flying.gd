class_name DecisionEngineFlying
extends DecisionEngine

@export var idle_state : EnemyState
@export var move_state : EnemyState
@export var chase_state : EnemyState
@export var attack_state : EnemyState
@export var stun_state : EnemyState
@export var death_state : EnemyState


func _ready() -> void:
	await super() # Maintains important setup code & timing
	# Implement your own scripts here
	pass


# All the conditions for making decisions go in this function
func decide() -> EnemyState:
	if blackboard.damage_source:
		if blackboard.health <= 0:
			return death_state
		else:
			return stun_state
	
	if current_state is ESDeath or not blackboard.can_decide:
		return null
	
	if blackboard.target:
		if attack_state.can_attack():
			return attack_state
		return chase_state
	return move_state # default state
