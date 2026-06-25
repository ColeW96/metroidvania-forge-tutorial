class_name PlayerStateShootDiag extends PlayerState

var degrees_rotated : float = deg_to_rad( 40 )

# What happens when this is initialized?
func init() -> void:
	pass


# What happens when we enter this state?
func enter() -> void:
	player.animation_player.play( "idle_shoot_diag" )
	player.bullet_spawn.position.y = -50
	#player.animation_player.animation_finished.connect( _animation_finished )
	player.jump_count = 0
	player.dash_count = 0
	pass


# What happens when we exit this state?
func exit() -> void:
	#player.animation_player.animation_finished.disconnect( _animation_finished )
	if player._cardinal_direction == Vector2.RIGHT:
		player.bullet_spawn.position.x = player.bullet_spawn_pos.x
	elif player._cardinal_direction == Vector2.LEFT:
		player.bullet_spawn.position.x = -player.bullet_spawn_pos.x
	player.bullet_spawn.rotation = 0
	player.bullet_spawn.position.y = player.bullet_spawn_pos.y
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
		#if player.direction.x != 0:
			#return run_shoot_up
		player.animation_player.play("shoot_diag")
		player.spawn_bullet()
		return null
	if _event.is_action_pressed("morph") and player.can_morph():
		return ball
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
	
	if not Input.is_action_pressed("shoot_diag"):
		return idle_shoot
	#if player.direction.x != 0:
		#return run_shoot
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
