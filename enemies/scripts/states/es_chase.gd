class_name ESChase
extends EnemyState

@export var chase_speed : float = 100.0


func enter() -> void:
	enemy.play_animation( animation_name if animation_name else "chase" )
	pass


func re_enter() -> void:
	# what happens if the state is called again?
	pass


func exit() -> void:
	# what do we need to clean up when exiting this state?
	pass


func physics_update( _delta : float ) -> void:
	var dir : float = sign( blackboard.target.global_position.x - enemy.global_position.x )
	enemy.change_dir( dir )
	enemy.velocity.x = dir * chase_speed
	pass
