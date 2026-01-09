class_name PlayerStateFall extends PlayerState

const BULLET = preload("uid://bdoia83dmojob")

@export var fall_gravity_multiplier : float = 1.165
@export var coyote_time : float = 0.125
@export var jump_buffer_time : float = 0.2

var coyote_timer : float = 0.0
var buffer_timer : float = 0.0

@onready var bullet_spawn: Node2D = $"../../BulletSpawn"


# What happens when this is initialized?
func init() -> void:
	pass


# What happens when we enter this state?
func enter() -> void:
	player.animation_player.play( "jump" )
	player.animation_player.pause()
	player.gravity_multiplier = fall_gravity_multiplier
	if player.previous_state == jump:
		coyote_timer = 0
	else:
		coyote_timer = coyote_time
	pass


# What happens when we exit this state?
func exit() -> void:
	player.gravity_multiplier = 1.0
	buffer_timer = 0
	pass


# What happens with input?
func handle_input( _event : InputEvent ) -> PlayerState:
	if _event.is_action_pressed("shoot"):
		return fall_shoot
	
	if _event.is_action_pressed( "jump" ):
		if coyote_timer > 0:
			return jump
		else:
			buffer_timer = jump_buffer_time
	return next_state


# What happens each process tick in this state?
func process( _delta: float ) -> PlayerState:
	if Input.is_action_just_pressed("shoot"):
		spawn_bullet()
	set_jump_frame()
	coyote_timer -= _delta
	buffer_timer -= _delta
	return next_state


# What happens each physics process tick in this state?
func physics_process( _delta: float ) -> PlayerState:
	if player.is_on_floor():
		#player.add_debug_indicator()
		if buffer_timer > 0:
			return jump
		return idle
	player.velocity.x = player.direction.x * player.move_speed
	return next_state


func set_jump_frame() -> void:
	var frame : float = remap( player.velocity.y, 0.0, player.max_fall_velocity, 0.5, 1.0 )
	player.animation_player.seek( frame, true )
	pass


func spawn_bullet() -> void:
	var bullet : Bullet = BULLET.instantiate()
	get_tree().root.add_child( bullet )
	if player._cardinal_direction == Vector2.LEFT:
		bullet.move_direction = Vector2.LEFT
	bullet.global_position = bullet_spawn.global_position
	pass
