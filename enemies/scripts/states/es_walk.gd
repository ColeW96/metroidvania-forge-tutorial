class_name ESWalk
extends EnemyState


@export var walk_speed : float = 50.0


func enter() -> void:
	var anim : String = animation_name if animation_name else "walk"
	enemy.play_animation( anim )
	pass


func re_enter() -> void:
	# what happens if the state is called again?
	pass


func exit() -> void:
	# what do we need to clean up when exiting this state?
	pass


func physics_update( _delta : float ) -> void:
	if enemy.is_on_wall():
		enemy.change_dir( -blackboard.dir )
	enemy.velocity.x = walk_speed * blackboard.dir
	pass
