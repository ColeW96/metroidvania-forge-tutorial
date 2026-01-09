class_name PlayerStateCrouchShoot extends PlayerState


# What happens when this is initialized?
func init() -> void:
	pass


# What happens when we enter this state?a
func enter() -> void:
	player.bullet_spawn.position.y = -8
	player.spawn_bullet()
	player.animation_player.play( "crouch_shoot" )
	player.animation_player.animation_finished.connect( _animation_finished )
	pass


# What happens when we exit this state?
func exit() -> void:
	if player._cardinal_direction == Vector2.RIGHT:
		player.bullet_spawn.position.x = player.bullet_spawn_pos.x
	elif player._cardinal_direction == Vector2.LEFT:
		player.bullet_spawn.position.x = -player.bullet_spawn_pos.x
	player.bullet_spawn.position.y = player.bullet_spawn_pos.y
	player.animation_player.animation_finished.disconnect( _animation_finished )
	pass


# What happens with input?
func handle_input( _event : InputEvent ) -> PlayerState:
	if _event.is_action_pressed( "jump" ):
		player.one_way_platform_shapecast.force_shapecast_update()
		if player.one_way_platform_shapecast.is_colliding():
			player.position.y += 4
			return fall
		return jump
	return next_state


# What happens each process tick in this state?
func process( _delta: float ) -> PlayerState:
	if player._cardinal_direction == Vector2.RIGHT:
		player.bullet_spawn.position.x = player.bullet_spawn_pos.x - 3
	elif player._cardinal_direction == Vector2.LEFT:
		player.bullet_spawn.position.x = -player.bullet_spawn_pos.x + 3
	return next_state


# What happens each physics process tick in this state?
func physics_process( _delta: float ) -> PlayerState:
	return next_state


func _animation_finished( _new_anim_name : String ) -> void:
	player.change_state( crouch )
	pass
