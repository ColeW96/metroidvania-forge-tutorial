class_name Blackboard extends Resource

var health : float = 3
var target : Player = null
var distance_to_target : float = -1
var can_decide : bool = true
var edge_detected : bool = false
var damage_source : AttackArea = null
var dir : float = 1.0


func update_distance_to_target( pos : Vector2 ) -> void:
	if target:
		distance_to_target = pos.distance_to( target.global_position )
	else:
		distance_to_target = -1
	pass
