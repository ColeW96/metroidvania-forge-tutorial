class_name PlayerStateBall extends PlayerState

const MORPH_AUDIO = preload("uid://dqd7dlshyeseu")
const MORPH_OUT_AUDIO = preload("uid://b03xvcklnp5ja")
const JUMP = preload("uid://b7y7gfqr173i5")
const LAND = preload("uid://bkueq2alnhrv2")

@export var jump_velocity : float = 400.0

var on_floor : bool = true

@onready var ball_ray_up: RayCast2D = %BallRayUp
@onready var ball_ray_down: RayCast2D = %BallRayDown



# What happens when this is initialized?
func init() -> void:
	pass


# What happens when we enter this state?
func enter() -> void:
	player.animation_player.play("ball")
	
	if player.previous_state == take_damage:
		return
	
	var shape : CapsuleShape2D = player.collision_stand.get_shape() as CapsuleShape2D
	shape.radius = 11.0
	shape.height = 22.0
	player.collision_stand.position.y = -11.0
	player.da_stand.position.y = -11.0
	
	if player.is_on_floor():
		player.velocity.y -= 100
	# maybe tween color on morph
	Audio.play_spatial_sound(MORPH_AUDIO, player.global_position, false, true, 0.5)
	pass


# What happens when we exit this state?
func exit() -> void:
	player.animation_player.speed_scale = 1
	
	if player.requested_state == take_damage:
		return
	
	var shape : CapsuleShape2D = player.collision_stand.get_shape() as CapsuleShape2D
	shape.radius = 8.0
	shape.height = 46.0
	player.collision_stand.position.y = -23.0
	player.da_stand.position.y = -23.0
	
	if player.is_on_floor():
		player.velocity.y -= 100
	Audio.play_spatial_sound(MORPH_OUT_AUDIO, player.global_position, false, true, 0.5)
	pass


# What happens with input?
func handle_input( event : InputEvent ) -> PlayerState:
	if event.is_action_pressed("morph"):
		if can_stand():
			if player.is_on_floor():
				return idle
			else:
				return fall
	if event.is_action_pressed("jump") and player.is_on_floor():
		if Input.is_action_pressed("down"):
			player.one_way_platform_shapecast.force_shapecast_update()
			if player.one_way_platform_shapecast.is_colliding():
				player.position.y += 4
				return null
		player.velocity.y -= jump_velocity
		Audio.play_spatial_sound(JUMP, player.global_position, false, true, 0.25)
		VisualEffects.jump_dust( player.global_position )
	return null


# What happens each process tick in this state?
func process( _delta: float ) -> PlayerState:
	if player.direction.x == 0 and player.animation_player.current_animation == "ball":
		player.animation_player.speed_scale = 0
	else:
		player.animation_player.speed_scale = 1
	return null


# What happens each physics process tick in this state?
func physics_process( _delta: float ) -> PlayerState:
	player.velocity.x = player.direction.x * player.move_speed
	
	if on_floor:
		if not player.is_on_floor():
			on_floor = false
	else:
		if player.is_on_floor():
			on_floor = true
			VisualEffects.land_dust(player.global_position)
			Audio.play_spatial_sound(LAND, player.global_position, false, true, 0.5)
	return next_state


func can_stand() -> bool:
	ball_ray_up.force_raycast_update()
	ball_ray_down.force_raycast_update()
	if ball_ray_down.is_colliding() and ball_ray_up.is_colliding():
		return false
	return true
