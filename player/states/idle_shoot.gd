class_name PlayerStateIdleShoot extends PlayerState

var timer : float = 0.0

# What happens when this is initialized?
func init() -> void:
	pass


# What happens when we enter this state?
func enter() -> void:
	if player.previous_state == idle or player.previous_state == idle_shoot:
		player.spawn_bullet()
		player.animation_player.play( "shoot" )
	else:
		player.animation_player.play("idle_shoot")
	timer = 2.0
	#player.animation_player.animation_finished.connect( _animation_finished )
	player.jump_count = 0
	player.dash_count = 0
	pass


# What happens when we exit this state?
func exit() -> void:
	#player.animation_player.animation_finished.disconnect( _animation_finished )
	pass


# What happens with input?
func handle_input( _event : InputEvent ) -> PlayerState:
	if _event.is_action_pressed("dash") and player.can_dash():
		return dash
	if _event.is_action_pressed("attack"):
		return attack
	if _event.is_action_pressed("jump"):
		return jump
	if _event.is_action_pressed("shoot"):
		if player.direction.x != 0:
			return run_shoot
		player.animation_player.play("shoot")
		player.spawn_bullet()
		timer = 2
		return null
	if _event.is_action_pressed("shoot_diag"):
		return shoot_diag
	if _event.is_action_pressed("morph") and player.can_morph():
		return ball
	return next_state


# What happens each process tick in this state?
func process( _delta: float ) -> PlayerState:
	timer -= _delta
	if timer <= 0:
		return idle
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
