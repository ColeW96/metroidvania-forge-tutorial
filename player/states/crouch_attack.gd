class_name PlayerStateCrouchAttack extends PlayerState

const AUDIO_ATTACK = preload("uid://cvajccfk2oxjq")

@export var combo_time_window : float = 0.2
@export var speed : float = 150.0
var timer : float = 0.0
var combo : int = 0

@onready var crouch_attack_sprite: Sprite2D = %CrouchAttackSprite


# What happens when this is initialized?
func init() -> void:
	crouch_attack_sprite.visible = false
	pass


# What happens when we enter this state?
func enter() -> void:
	player.attack_area.position.y = -14
	do_attack()
	player.animation_player.animation_finished.connect( _on_animation_finished )
	pass


# What happens when we exit this state?
func exit() -> void:
	player.attack_area.position.y = -23
	timer = 0
	combo = 0
	crouch_attack_sprite.visible = false
	player.animation_player.animation_finished.disconnect( _on_animation_finished )
	next_state = null
	pass


# What happens with input?
func handle_input( _event : InputEvent ) -> PlayerState:
	if _event.is_action_pressed("attack"):
		timer = combo_time_window
	if _event.is_action_released("down"):
		return idle
	if _event.is_action_pressed("dash") and player.can_dash():
		return dash
	if _event.is_action_pressed("morph") and player.can_morph():
		return ball
	return next_state


# What happens each process tick in this state?
func process( delta: float ) -> PlayerState:
	timer -= delta
	return next_state


# What happens each physics process tick in this state?
func physics_process( _delta: float ) -> PlayerState:
	player.velocity.x = 0
	return null


func do_attack() -> void:
	var anim_name : String = "crouch_attack"
	if combo > 0:
		anim_name = "crouch_attack_2"
	player.animation_player.play(anim_name)
	player.attack_area.activate()
	Audio.play_spatial_sound(AUDIO_ATTACK, player.global_position, false, true, 0.25)
	pass


func _end_attack() -> void:
	if timer > 0:
		combo = wrapi( combo + 1, 0, 2 )
		do_attack()
	else:
		if player.is_on_floor():
			next_state = crouch
		else:
			next_state = fall
	pass


func _on_animation_finished( _anim_name : String ) -> void:
	_end_attack()
	pass
