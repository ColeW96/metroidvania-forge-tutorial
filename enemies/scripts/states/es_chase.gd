class_name ESChase
extends EnemyState

@export var chase_speed : float = 100.0

var dir : float = 1.0
var dir_changed_cooldown : float = 0.0

func enter() -> void:
	enemy.play_animation( animation_name if animation_name else "chase" )
	dir_changed_cooldown = -1
	pass


func re_enter() -> void:
	# what happens if the state is called again?
	pass


func exit() -> void:
	# what do we need to clean up when exiting this state?
	pass


func physics_update( delta : float ) -> void:
	if blackboard.target:
		if dir_changed_cooldown > 0:
			dir_changed_cooldown -= delta
		else:
			dir_changed_cooldown = 0.5
			dir = sign( blackboard.target.global_position.x - enemy.global_position.x )
			enemy.change_dir( dir )
		enemy.velocity.x = dir * chase_speed
	pass
