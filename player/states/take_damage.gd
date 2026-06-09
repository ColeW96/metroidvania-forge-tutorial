class_name PlayerStateTakeDamage extends PlayerState

const HURT = preload("uid://d0eldpjdmfac8")

@export var move_speed : float = 100.0
@export var invulnerable_duration : float = 0.5
var time : float = 0.0
var dir : float = 1.0
@onready var damage_area: DamageArea = %DamageArea



# What happens when this is initialized?
func init() -> void:
	damage_area.damage_taken.connect( _on_damage_taken )
	pass


# What happens when we enter this state?
func enter() -> void:
	damage_area.make_invulnerable( invulnerable_duration )
	Audio.play_spatial_sound(HURT, player.global_position, false, true, 0.45)
	VisualEffects.camera_shake()
	
	if player.previous_state == ball:
		time = 0.3
		return
	
	player.animation_player.play( "take_damage" )
	time = player.animation_player.current_animation_length
	pass


# What happens when we exit this state?
func exit() -> void:
	pass


# What happens with input?
func handle_input( _event : InputEvent ) -> PlayerState:
	return null


# What happens each process tick in this state?
func process( delta: float ) -> PlayerState:
	time -= delta
	if time <= 0:
		if player.hp <= 0:
			return death
		elif player.previous_state == ball:
			return ball
		else:
			return idle
	return null


# What happens each physics process tick in this state?
func physics_process( _delta: float ) -> PlayerState:
	player.velocity.x = move_speed * dir
	return null


func _on_damage_taken( attack_area : AttackArea ) -> void:
	if player.current_state == death:
		return
	player.change_state( self )
	if attack_area.global_position.x < player.global_position.x:
		dir = 1.0
	else:
		dir = -1.0
	pass
