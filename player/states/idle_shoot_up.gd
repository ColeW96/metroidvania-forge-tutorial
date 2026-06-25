class_name PlayerStateIdleShootUp extends PlayerState


@export var deceleration_rate : float = 10.0
var can_shoot : bool = false
var timer : float = 0.0
var anim_length : float = 0.0
var anim_length_offset : float = .01

# What happens when this is initialized?
func init() -> void:
	pass


# What happens when we enter this state?
func enter() -> void:
	player.aiming_up = true
	player.update_direction()
	position_and_rotate_bullet_spawn()
	player.animation_player.play( "idle_shoot_up" )
	pass


# What happens when we exit this state?
func exit() -> void:
	player.aiming_up = false
	reset_bullet_spawn()
	can_shoot = false
	pass


# What happens with input?
func handle_input( _event : InputEvent ) -> PlayerState:
	if _event.is_action_pressed("dash") and player.can_dash():
		return dash
	
	if _event.is_action_pressed("shoot"):
		player.animation_player.play("shoot_up")
		player.spawn_bullet()
		return null
	
	if _event.is_action_pressed( "jump" ):
		player.one_way_platform_shapecast.force_shapecast_update()
		if player.one_way_platform_shapecast.is_colliding():
			player.position.y += 4
			return fall
		return jump
	
	if _event.is_action_pressed("morph") and player.can_morph():
		return ball
	return next_state


# What happens each process tick in this state?
func process( _delta: float ) -> PlayerState:
	if not Input.is_action_pressed("up") and Input.is_action_pressed("shoot_diag"):
		return shoot_diag
	if player.direction.y > -0.5:
		return idle_shoot
	elif Input.is_action_pressed("up") and Input.is_action_pressed("right") and Input.is_action_pressed("left"):
		return null
	elif Input.is_action_pressed("up") and Input.is_action_pressed("right"):
		return run_shoot_up
	elif Input.is_action_pressed("up") and Input.is_action_pressed("left"):
		return run_shoot_up
	return next_state


# What happens each physics process tick in this state?
func physics_process( _delta: float ) -> PlayerState:
	player.velocity.x = 0
	if player.is_on_floor() == false:
		return fall
	return next_state


func _on_animation_finished( _new_anim_name : String ) -> void:
	can_shoot = true
	pass


func position_and_rotate_bullet_spawn() -> void:
	var rotate_up : float = deg_to_rad( -90 )
	player.bullet_spawn.rotation = rotate_up
	player.bullet_spawn.position.x = 0
	player.bullet_spawn.position.y = -59
	pass


func reset_bullet_spawn() -> void:
	player.bullet_spawn.rotation = 0
	player.bullet_spawn.position = player.bullet_spawn_pos
	pass
