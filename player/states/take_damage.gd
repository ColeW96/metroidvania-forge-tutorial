class_name PlayerStateTakeDamage extends PlayerState

@export var move_speed : float = 100.0
@export var invulnerable_duration : float = 0.5
var time : float = 0.0
var dir : float = 1.0
@onready var damage_area: DamageArea = %DamageArea
@onready var hurt_audio: AudioStreamPlayer2D = %HurtAudio



# What happens when this is initialized?
func init() -> void:
	damage_area.damage_taken.connect( _on_damage_taken )
	pass


# What happens when we enter this state?
func enter() -> void:
	player.animation_player.play( "take_damage" )
	time = player.animation_player.current_animation_length
	damage_area.make_invulnerable( invulnerable_duration )
	hurt_audio.play()
	VisualEffects.camera_shake()
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
