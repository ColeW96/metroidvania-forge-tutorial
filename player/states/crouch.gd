class_name PlayerStateCrouch extends PlayerState


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
	var prev_state : PlayerState = player.previous_state
	if prev_state == crouch_attack:
		player.animation_player.play( "crouch" )
		anim_length = player.animation_player.current_animation_length
		player.animation_player.advance(anim_length - anim_length_offset)
	else:
		player.animation_player.play( "crouch" )
	player.collision_stand.disabled = true
	player.collision_crouch.disabled = false
	player.da_stand.disabled = true
	player.da_crouch.disabled = false
	player.bullet_spawn.position.y = -8
	pass


# What happens when we exit this state?
func exit() -> void:
	player.collision_stand.set_deferred( "disabled", false )
	player.collision_crouch.set_deferred( "disabled", true )
	player.da_stand.set_deferred( "disabled", false )
	player.da_crouch.set_deferred( "disabled", true )
	can_shoot = false
	player.bullet_spawn.position.y = player.bullet_spawn_pos.y
	pass


# What happens with input?
func handle_input( _event : InputEvent ) -> PlayerState:
	if _event.is_action_pressed("dash") and player.can_dash():
		return dash
	if _event.is_action_pressed("attack"):
		return crouch_attack
	if _event.is_action_pressed("shoot"):
		player.animation_player.play("crouch_shoot")
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
	
	if player.direction.y <= 0.5:
		return idle
	return next_state


# What happens each physics process tick in this state?
func physics_process( _delta: float ) -> PlayerState:
	player.velocity.x -= player.velocity.x * deceleration_rate * _delta
	if player.is_on_floor() == false:
		return fall
	return next_state


func _on_animation_finished( _new_anim_name : String ) -> void:
	can_shoot = true
	pass
