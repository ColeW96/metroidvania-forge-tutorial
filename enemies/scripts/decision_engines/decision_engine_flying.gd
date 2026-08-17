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
		if blackboard.damage_source.owner is Player:
			blackboard.target = blackboard.damage_source.owner
		elif blackboard.damage_source.owner is Bullet:
			blackboard.target = get_tree().get_first_node_in_group("Player")
		
		if blackboard.health <= 0:
			return death_state
		
		if blackboard.damage_source.get_parent() is Bullet:
			return null
		
		if current_state is ESFlyAttack:
			blackboard.damage_source = null
			return null
		
		return stun_state
	
	if current_state is ESDeath or not blackboard.can_decide:
		return null
	
	if blackboard.target:
		if attack_state.can_attack():
			return attack_state
		return chase_state
	return move_state # default state
