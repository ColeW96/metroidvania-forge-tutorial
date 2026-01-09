class_name PlayerStateIdleShoot extends PlayerState


# What happens when this is initialized?
func init() -> void:
	pass


# What happens when we enter this state?
func enter() -> void:
	player.animation_player.play( "idle_shoot" )
	player.animation_player.animation_finished.connect( _animation_finished )
	pass


# What happens when we exit this state?
func exit() -> void:
	player.animation_player.animation_finished.disconnect( _animation_finished )
	pass


# What happens with input?
func handle_input( _event : InputEvent ) -> PlayerState:
	if _event.is_action_pressed("jump"):
		return jump_shoot
	if _event.is_action_pressed("shoot"):
		if player.direction.x != 0:
			return run_shoot
		return shoot
	return next_state


# What happens each process tick in this state?
func process( _delta: float ) -> PlayerState:
	if player.direction.x != 0:
		return run_shoot
	elif player.direction.y > 0.5:
		return crouch
	elif player.direction.y < -0.5:
		return idle_shoot_up
	return next_state


# What happens each physics process tick in this state?
func physics_process( _delta: float ) -> PlayerState:
	player.velocity.x = 0
	if player.is_on_floor() == false:
		return fall
	return next_state


func _animation_finished( _new_anim_name : String ) -> void:
	player.change_state( idle )
	pass
