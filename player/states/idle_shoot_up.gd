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
	player.animation_player.play( "idle_shoot_up" )
	player.collision_stand.disabled = true
	player.collision_crouch.disabled = false
	player.bullet_spawn.position.y = -8
	pass


# What happens when we exit this state?
func exit() -> void:
	player.collision_stand.disabled = false
	player.collision_crouch.disabled = true
	can_shoot = false
	player.bullet_spawn.position.y = player.bullet_spawn_pos.y
	pass


# What happens with input?
func handle_input( _event : InputEvent ) -> PlayerState:
	
	if _event.is_action_pressed("shoot"):
		return shoot_up
	
	if _event.is_action_pressed( "jump" ):
		player.one_way_platform_shapecast.force_shapecast_update()
		if player.one_way_platform_shapecast.is_colliding():
			player.position.y += 4
			return fall
		return jump
	return next_state


# What happens each process tick in this state?
func process( _delta: float ) -> PlayerState:
	
	if player.direction.y > -0.9:
		return run_shoot_up
	elif Input.is_action_pressed("up") and Input.is_action_just_pressed("right"):
		return run_shoot_up
	elif Input.is_action_pressed("up") and Input.is_action_just_pressed("left"):
		return run_shoot_up
	elif Input.is_action_just_released("up"):
		return idle_shoot
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
