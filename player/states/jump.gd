class_name PlayerStateJump extends PlayerState

const BULLET = preload("uid://bdoia83dmojob")
const JUMP = preload("uid://b7y7gfqr173i5")

@export var jump_velocity : float = 450.0

@onready var bullet_spawn: Node2D = $"../../BulletSpawn"

# What happens when this is initialized?
func init() -> void:
	pass


# What happens when we enter this state?
func enter() -> void:
	if player.is_on_floor():
		VisualEffects.jump_dust( player.global_position )
	else:
		VisualEffects.hit_dust( player.global_position )
	player.animation_player.play( "jump" )
	player.animation_player.pause()
	
	do_jump()
	
	# check if this is a buffer jump
	# if it is, handle jump button release condition retroactively
	if player.previous_state == fall and not Input.is_action_pressed("jump"):
		await get_tree().physics_frame
		player.velocity.y *= 0.5
		player.change_state( fall )
	pass


# What happens when we exit this state?
func exit() -> void:
	pass


# What happens with input?
func handle_input( event : InputEvent ) -> PlayerState:
	if event.is_action_pressed("dash") and player.dash_count == 0:
		return dash
	if event.is_action_pressed("attack"):
		if player.ground_slam and Input.is_action_pressed("down"):
			return ground_slam
		return attack
	if event.is_action_pressed("shoot"):
		return jump_shoot
	if event.is_action_released("jump"):
		#player.velocity.y *= 0.5
		return fall
	if event.is_action_pressed("morph") and player.can_morph():
		return ball
	return next_state


# What happens each process tick in this state?
func process( _delta: float ) -> PlayerState:
	if Input.is_action_just_pressed("shoot"):
		spawn_bullet()
	set_jump_frame()
	return next_state


# What happens each physics process tick in this state?
func physics_process( _delta: float ) -> PlayerState:
	if player.is_on_floor():
		return idle
	elif player.velocity.y >= 0:
		return fall
	player.velocity.x = player.direction.x * player.move_speed
	return next_state


func do_jump() -> void:
	if player.jump_count > 0:
		if player.double_jump == false:
			return
		elif player.jump_count > 1:
			return
	player.jump_count += 1
	player.velocity.y = -jump_velocity
	Audio.play_spatial_sound(JUMP, player.global_position, false, true, 0.25)


func set_jump_frame() -> void:
	var frame : float = remap( player.velocity.y, -jump_velocity, 0.0, 0.0, 0.5 )
	player.animation_player.seek( frame, true )
	pass


func spawn_bullet() -> void:
	var bullet : Bullet = BULLET.instantiate()
	get_tree().root.add_child( bullet )
	if player._cardinal_direction == Vector2.LEFT:
		bullet.move_direction = Vector2.LEFT
	bullet.global_position = bullet_spawn.global_position
	pass
