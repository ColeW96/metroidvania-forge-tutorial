class_name PlayerStateShootUp extends PlayerState


# What happens when this is initialized?
func init() -> void:
	pass


# What happens when we enter this state?
func enter() -> void:
	player.aiming_up = true
	position_and_rotate_bullet_spawn()
	player.spawn_bullet()
	player.animation_player.play( "shoot_up" )
	player.animation_player.animation_finished.connect( _animation_finished )
	pass


# What happens when we exit this state?
func exit() -> void:
	player.aiming_up = false
	reset_bullet_spawn()
	player.animation_player.animation_finished.disconnect( _animation_finished )
	pass


# What happens with input?
func handle_input( _event : InputEvent ) -> PlayerState:
	if _event.is_action_pressed( "jump" ):
		return jump_shoot
	return next_state


# What happens each process tick in this state?
func process( _delta: float ) -> PlayerState:
	if player.direction.x != 0:
		return run_shoot
	return next_state


# What happens each physics process tick in this state?
func physics_process( _delta: float ) -> PlayerState:
	player.velocity.x = 0
	if player.is_on_floor() == false:
		return fall
	return next_state


func _animation_finished( _new_anim_name : String ) -> void:
	player.change_state( idle_shoot )
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
