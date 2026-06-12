class_name ESIdle
extends EnemyState

var timer : float = 0.0
var duration : float = 0.0


func enter() -> void:
	enemy.velocity.x = 0
	enemy.play_animation( animation_name if animation_name else "idle" )
	duration = enemy.animation.current_animation_length
	timer = 0
	blackboard.edge_detected = false
	blackboard.can_decide = false
	blackboard.target = null
	pass


func re_enter() -> void:
	# what happens if the state is called again?
	pass


func exit() -> void:
	blackboard.can_decide = true
	pass


func physics_update( delta : float ) -> void:
	timer += delta
	if timer >= duration:
		enemy.change_dir( -blackboard.dir )
		blackboard.can_decide = true
	pass
