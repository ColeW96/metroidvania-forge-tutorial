class_name PlayerStateRun extends PlayerState


# What happens when this is initialized?
func init() -> void:
	pass


# What happens when we enter this state?
func enter() -> void:
	if player.previous_state == run_shoot:
		var frame : float = player.animation_player.current_animation_position
		player.animation_player.play( "run" )
		player.animation_player.seek( frame, true )
	else:
		player.animation_player.play( "run" )
	pass


# What happens when we exit this state?
func exit() -> void:
	pass


# What happens with input?
func handle_input( _event : InputEvent ) -> PlayerState:
	if _event.is_action_pressed( "jump" ):
		return jump
	if _event.is_action_pressed( "shoot" ):
		return run_shoot
		
	return next_state


# What happens each process tick in this state?
func process( _delta: float ) -> PlayerState:
	
	if player.direction.x == 0:
		return idle
	elif player.direction.y > 0.5:
		return crouch
	elif player.direction.y < -0.5:
		return run_shoot_up
	return next_state


# What happens each physics process tick in this state?
func physics_process( _delta: float ) -> PlayerState:
	player.velocity.x = player.direction.x * player.move_speed
	
	if player.is_on_floor() == false:
		return fall
	return next_state
