class_name ESFly
extends EnemyState

@export var speed : float = 50.0

var left_limit : float
var right_limit : float


func enter() -> void:
	_set_limits()
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
	if enemy.is_on_wall():
		enemy.change_dir( -blackboard.dir )
	elif enemy.global_position.x <= left_limit and blackboard.dir < 0:
		enemy.change_dir( 1.0 )
	elif enemy.global_position.x >= right_limit and blackboard.dir > 0:
		enemy.change_dir( -1.0 )
	enemy.velocity = Vector2( speed * blackboard.dir, 0 )
	pass


func _set_limits() -> void:
	left_limit = owner.global_position.x - 5000
	right_limit = owner.global_position.x + 5000
	for c in owner.get_children():
		if c is PatrolLimit:
			if c.side == Side.SIDE_LEFT:
				left_limit = c.global_position.x
			else:
				right_limit = c.global_position.x
	pass
