class_name PlayerStateJumpShoot extends PlayerState

@export var jump_velocity : float = 450.0


# What happens when this is initialized?
func init() -> void:
	pass


# What happens when we enter this state?
func enter() -> void:
	player.bullet_spawn.position.y = -32
	player.animation_player.play( "jump_shoot" )
	player.animation_player.pause()
	if player.is_on_floor():
		player.velocity.y = -jump_velocity
	
	# check if this is a buffer jump
	# if it is, handle jump button release condition retroactively
	if player.previous_state == fall_shoot and not Input.is_action_pressed("jump"):
		await get_tree().physics_frame
		player.velocity.y *= 0.5
		player.change_state( fall_shoot )
	pass


# What happens when we exit this state?
func exit() -> void:
	if player._cardinal_direction == Vector2.RIGHT:
		player.bullet_spawn.position.x = player.bullet_spawn_pos.x
	elif player._cardinal_direction == Vector2.LEFT:
		player.bullet_spawn.position.x = -player.bullet_spawn_pos.x
	player.bullet_spawn.position.y = player.bullet_spawn_pos.y
	pass


# What happens with input?
func handle_input( event : InputEvent ) -> PlayerState:
	if event.is_action_released("jump"):
		player.velocity.y *= 0.5
		return fall_shoot
	return next_state


# What happens each process tick in this state?
func process( _delta: float ) -> PlayerState:
	player.update_direction()
	if player._cardinal_direction == Vector2.RIGHT:
		player.bullet_spawn.position.x = player.bullet_spawn_pos.x + 5
	if player._cardinal_direction == Vector2.LEFT:
		player.bullet_spawn.position.x = -player.bullet_spawn_pos.x - 5
	
	if Input.is_action_just_pressed("shoot"):
		player.spawn_bullet()
	set_jump_frame()
	return next_state


# What happens each physics process tick in this state?
func physics_process( _delta: float ) -> PlayerState:
	if player.is_on_floor():
		return idle
	elif player.velocity.y >= 0:
		return fall_shoot
	player.velocity.x = player.direction.x * player.move_speed
	return next_state


func set_jump_frame() -> void:
	var frame : float = remap( player.velocity.y, -jump_velocity, 0.0, 0.0, 0.5 )
	player.animation_player.seek( frame, true )
	pass
