class_name PlayerStateGroundSlam extends PlayerState

const DASH_AUDIO = preload("uid://dh6vli53gmirk")
const BOOM_AUDIO = preload("uid://cf85is3e4o3kb")
const BREAK_WOOD_AUDIO = preload("uid://cpqpq5d0arguu")
const HIT_WOOD_LARGE = preload("uid://dm5k2wmv5w6sh")
const HIT_WOOD_MEDIUM = preload("uid://gjrpwjdumgxp")
const HIT_WOOD_SMALL = preload("uid://dhrfnkg8xl0lk")


@export var velocity : float = 400.0
@export var effect_delay : float = 0.075
var effect_timer : float = 0.0

@onready var damage_area: DamageArea = %DamageArea
@onready var ground_slam_shapecast: ShapeCast2D = %GroundSlamShapecast
@onready var ground_slam_attack_area: AttackArea = %GroundSlamAttackArea

# What happens when this is initialized?
func init() -> void:
	pass


# What happens when we enter this state?
func enter() -> void:
	player.animation_player.play("ground_slam")
	player.sprite.tween_color(0.5, Color.ORANGE_RED)
	Audio.play_spatial_sound(DASH_AUDIO, player.global_position)
	damage_area.start_invulnerable()
	ground_slam_attack_area.set_active()
	pass


# What happens when we exit this state?
func exit() -> void:
	VisualEffects.camera_shake( 10.0 )
	VisualEffects.land_dust( player.global_position )
	VisualEffects.hit_dust( player.global_position )
	Audio.play_spatial_sound( BOOM_AUDIO, player.global_position )
	damage_area.end_invulnerable()
	ground_slam_attack_area.set_active( false )
	pass


# What happens with input?
func handle_input( _event : InputEvent ) -> PlayerState:
	return null


# What happens each process tick in this state?
func process( delta: float ) -> PlayerState:
	check_collisions( delta )
	effect_timer -= delta
	if effect_timer < 0:
		effect_timer = effect_delay
		player.sprite.ghost( Color.ORANGE_RED )
	return null


# What happens each physics process tick in this state?
func physics_process( _delta: float ) -> PlayerState:
	player.velocity = Vector2(0, velocity)
	if player.is_on_floor():
		if not check_collisions(_delta):
			return idle
	return next_state


func check_collisions( delta : float ) -> bool:
	ground_slam_shapecast.target_position.y = velocity * delta
	ground_slam_shapecast.force_shapecast_update()
	if ground_slam_shapecast.is_colliding():
		for i in ground_slam_shapecast.get_collision_count():
			var c = ground_slam_shapecast.get_collider( i )
			var pos : Vector2 = ground_slam_shapecast.get_collision_point( i )
			
			VisualEffects.hit_dust( pos )
			VisualEffects.camera_shake( 10 )
			
			if c.get_parent() is Breakable:
				var b : Breakable = c.get_parent()
				if b.get_parent() is AbilityPickup:
					b.destroyed.emit()
				else:
					b.queue_free()
					Audio.play_spatial_sound(b.destroy_audio, pos)
					for p in b.destroy_particles:
						VisualEffects.hit_particles( pos, Vector2.DOWN, p )
			else:
				c.queue_free()
				VisualEffects.hit_particles( pos, Vector2.DOWN, HIT_WOOD_LARGE )
				VisualEffects.hit_particles( pos, Vector2.DOWN, HIT_WOOD_MEDIUM )
				VisualEffects.hit_particles( pos, Vector2.UP, HIT_WOOD_SMALL )
				Audio.play_spatial_sound( BREAK_WOOD_AUDIO, pos )
		return true
	return false
