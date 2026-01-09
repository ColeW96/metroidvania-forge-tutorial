class_name PlayerStateRunShootUp extends PlayerState

var timer : float = 0.0
var degrees_rotated : float = deg_to_rad( 45 )

# What happens when this is initialized?
func init() -> void:
	pass


# What happens when we enter this state?
func enter() -> void:
	var frame : float = player.animation_player.current_animation_position
	player.bullet_spawn.position.y = -50
	player.animation_player.play( "run_shoot_up" )
	player.animation_player.seek( frame, true )
	pass


# What happens when we exit this state?
func exit() -> void:
	if player._cardinal_direction == Vector2.RIGHT:
		player.bullet_spawn.position.x = player.bullet_spawn_pos.x
	elif player._cardinal_direction == Vector2.LEFT:
		player.bullet_spawn.position.x = -player.bullet_spawn_pos.x
	player.bullet_spawn.rotation = 0
	player.bullet_spawn.position.y = player.bullet_spawn_pos.y
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
		player.bullet_spawn.position.x = player.bullet_spawn_pos.x + 1
		player.bullet_spawn.rotation = -degrees_rotated
	if player._cardinal_direction == Vector2.LEFT:
		player.bullet_spawn.position.x = -player.bullet_spawn_pos.x - 1
		player.bullet_spawn.rotation = degrees_rotated
	
	if Input.is_action_just_pressed("shoot"):
		player.spawn_bullet()
		timer = 2
	
	timer -= _delta
	
	if player.direction.x == 0:
		return idle_shoot
	elif player.direction.y > 0.5:
		return crouch
	elif player.direction.y > -0.5 and player.direction.y < 0.5:
		return run_shoot
	return next_state


# What happens each physics process tick in this state?
func physics_process( _delta: float ) -> PlayerState:
	
	if player._cardinal_direction == Vector2.RIGHT:
		player.velocity.x = 1 * player.move_speed
	elif player._cardinal_direction == Vector2.LEFT:
		player.velocity.x = -1 * player.move_speed
		
	#player.velocity.x = 0
	
	if player.is_on_floor() == false:
		return fall
	return next_state
