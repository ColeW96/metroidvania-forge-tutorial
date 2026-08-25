class_name ESNPBHDashAttack
extends EnemyState

@export var attack_range : float = 300.0
@export var cooldown : float = 5.0
@export var attack_area : AttackArea
@export var move_speed : float = 200.0
@export var move_speed_curve : Curve
@export var effect_color : Color

var timer : float = 0.0
var duration : float = 0.0
var on_cooldown : bool = false
var effect_time : float = 0.0
var effect_delay : float = 0.05

@onready var sprite_2d: PlayerSprite = $"../../Sprite2D"

func enter() -> void:
	enemy.play_animation( animation_name if animation_name else "dash_attack" )
	duration = enemy.animation.current_animation_length
	timer = 0
	blackboard.can_decide = false
	on_cooldown = true
	enemy.velocity.x = move_speed * blackboard.dir
	sprite_2d.tween_color( 1.5, effect_color )
	if attack_area:
		attack_area.flip( blackboard.dir )
	pass


func re_enter() -> void:
	pass


func exit() -> void:
	blackboard.can_decide = true
	run_cooldown()
	pass


func physics_update( delta : float ) -> void:
	timer += delta
	if timer >= duration:
		blackboard.can_decide = true
	if move_speed_curve:
		var sample : float = move_speed_curve.sample( timer / duration )
		enemy.velocity.x = move_speed * sample * blackboard.dir
		
	effect_time -= delta
	if effect_time < 0:
		effect_time = effect_delay
		sprite_2d.ghost( effect_color, Color( .5, .5, 2, 0 ) )
	pass


func can_attack() -> bool:
	var dist : float = blackboard.distance_to_target
	if dist <= attack_range and dist >= attack_range / 2 and not on_cooldown:
		return true
	return false


func run_cooldown() -> void:
	await get_tree().create_timer( cooldown ).timeout
	on_cooldown = false
	pass
