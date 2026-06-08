class_name DecisionEngineBasic
extends DecisionEngine

# Included in DecisionEngine:
# var enemy : Enemy
# var current_state : EnemyState
# var blackboard : Blackboard
@onready var es_walk: ESWalk = %ESWalk
@onready var es_stun: ESStun = %ESStun
@onready var es_death: ESDeath = %ESDeath


func _ready() -> void:
	await super() # Maintains important setup code & timing
	# Implement your own scripts here
	pass


# All the conditions for making decisions go in this function
func decide() -> EnemyState:
	# Example decisions
	if blackboard.damage_source:
		if blackboard.health <= 0:
			return es_death
		else:
			return es_stun
	
	if current_state is ESDeath or not blackboard.can_decide:
		return null
	
	if blackboard.edge_detected:
		enemy.change_dir( -blackboard.dir )
	
	#if blackboard.target:
		#if blackboard.distance_to_target < 40:
			#return attack_state?
		#return change_state?
	return es_walk # default state
