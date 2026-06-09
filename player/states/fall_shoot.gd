class_name PlayerStateFallShoot extends PlayerState

const LAND = preload("uid://bkueq2alnhrv2")

@export var fall_gravity_multiplier : float = 1.165
@export var coyote_time : float = 0.125
@export var jump_buffer_time : float = 0.2

var coyote_timer : float = 0.0
var buffer_timer : float = 0.0


# What happens when this is initialized?
func init() -> void:
	pass


# What happens when we enter this state?
func enter() -> void:
	player.bullet_spawn.position.y = -30
	player.animation_player.play( "jump_shoot" )
	player.animation_player.pause()
	player.gravity_multiplier = fall_gravity_multiplier
	
	if player.jump_count == 0:
		player.jump_count = 1
	
	var prev : PlayerState = player.previous_state
	if prev == jump_shoot or prev == attack or prev == dash:
		coyote_timer = 0
	elif prev == crouch:
		coyote_timer = 0
		player.jump_count = 1
	else:
		coyote_timer = coyote_time
	pass


# What happens when we exit this state?
func exit() -> void:
	if player._cardinal_direction == Vector2.RIGHT:
		player.bullet_spawn.position.x = player.bullet_spawn_pos.x
	elif player._cardinal_direction == Vector2.LEFT:
		player.bullet_spawn.position.x = -player.bullet_spawn_pos.x
	player.bullet_spawn.position.y = player.bullet_spawn_pos.y
	player.gravity_multiplier = 1.0
	buffer_timer = 0
	pass


# What happens with input?
func handle_input( _event : InputEvent ) -> PlayerState:
	if _event.is_action_pressed("dash") and player.can_dash():
		return dash
	if _event.is_action_pressed("attack"):
		if player.ground_slam and Input.is_action_pressed("down"):
			return ground_slam
		return attack
	if _event.is_action_pressed( "jump" ):
		if coyote_timer > 0:
			player.jump_count = 0
			return jump_shoot
		elif player.jump_count <= 1 and player.double_jump:
			return jump_shoot
		else:
			buffer_timer = jump_buffer_time
	if _event.is_action_pressed("morph") and player.can_morph():
		return ball
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
	coyote_timer -= _delta
	buffer_timer -= _delta
	return next_state


# What happens each physics process tick in this state?
func physics_process( _delta: float ) -> PlayerState:
	if player.is_on_floor():
		VisualEffects.land_dust( player.global_position )
		Audio.play_spatial_sound(LAND, player.global_position, false, true, 0.5)
		if buffer_timer > 0:
			return jump_shoot
		return idle_shoot
	player.velocity.x = player.direction.x * player.move_speed
	return next_state


func set_jump_frame() -> void:
	var frame : float = remap( player.velocity.y, 0.0, player.max_fall_velocity, 0.5, 1.0 )
	player.animation_player.seek( frame, true )
	pass
