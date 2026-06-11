class_name ESFlyChase
extends EnemyState

@export var speed : float = 100.0


func enter() -> void:
	var anim : String = animation_name if animation_name else "fly"
	enemy.play_animation( anim )
	pass


func re_enter() -> void:
	# what happens if the state is called again?
	pass


func exit() -> void:
	# what do we need to clean up when exiting this state?
	pass


func physics_update( _delta : float ) -> void:
	var dir : Vector2 = enemy.global_position.direction_to( blackboard.target.global_position )
	enemy.change_dir( sign( dir.x ) )
	enemy.velocity = speed * dir
	pass
