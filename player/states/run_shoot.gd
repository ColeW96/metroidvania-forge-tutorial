class_name PlayerStateRunShoot extends PlayerState

var timer : float = 0.0


# What happens when this is initialized?
func init() -> void:
	pass


# What happens when we enter this state?
func enter() -> void:
	var frame : float = player.animation_player.current_animation_position
	player.animation_player.play( "run_shoot" )
	player.animation_player.seek( frame, true )
	pass


# What happens when we exit this state?
func exit() -> void:
	timer = 2
	if player._cardinal_direction == Vector2.RIGHT:
		player.bullet_spawn.position.x = player.bullet_spawn_pos.x
	elif player._cardinal_direction == Vector2.LEFT:
		player.bullet_spawn.position.x = -player.bullet_spawn_pos.x
	pass


# What happens with input?
func handle_input( _event : InputEvent ) -> PlayerState:
	if _event.is_action_pressed( "jump" ):
		return jump_shoot
	if _event.is_action_pressed( "shoot" ):
		timer = 2
	return next_state


# What happens each process tick in this state?
func process( _delta: float ) -> PlayerState:
	player.update_direction()
	if player._cardinal_direction == Vector2.RIGHT:
		player.bullet_spawn.position.x = player.bullet_spawn_pos.x + 10
	if player._cardinal_direction == Vector2.LEFT:
		player.bullet_spawn.position.x = -player.bullet_spawn_pos.x - 10
	
	if Input.is_action_just_pressed("shoot"):
		player.spawn_bullet()
		timer = 2
	
	timer -= _delta
	
	if player.direction.x == 0:
		return idle_shoot
	elif player.direction.y > 0.5:
		return crouch
	elif player.direction.y < -0.5:
		return run_shoot_up
	elif timer <= 0:
		return run
	return next_state


# What happens each physics process tick in this state?
func physics_process( _delta: float ) -> PlayerState:
	player.velocity.x = player.direction.x * player.move_speed
	
	if player.is_on_floor() == false:
		return fall
	return next_state
