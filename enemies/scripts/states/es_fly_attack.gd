class_name ESFlyAttack
extends EnemyState

@export var attack_range : float = 100
@export var cooldown : float = 3.0
@export var attack_area : AttackArea
@export var speed : float = 200.0
@export var speed_curve : Curve

var dir : Vector2
var timer : float = 0.0
var duration : float = 0.0
var on_cooldown : bool = false
var speed_sample : float = 1.0


func enter() -> void:
	enemy.play_animation( animation_name if animation_name else "attack" )
	duration = enemy.animation.current_animation_length
	timer = 0
	blackboard.can_decide = false
	on_cooldown = true
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
	timer -= delta
	if timer >= duration:
		blackboard.can_decide = true
	if speed_curve:
		speed_sample = speed_curve.sample( timer / duration )
	dir = enemy.global_position.direction_to( blackboard.target.global_position )
	enemy.change_dir( sign( dir.x ) )
	enemy.velocity = dir * speed * speed_sample
	pass


func can_attack() -> bool:
	if blackboard.distance_to_target <= attack_range and not on_cooldown:
		return true
	return false


func run_cooldown() -> void:
	await get_tree().create_timer( cooldown ).timeout
	on_cooldown = false
	pass
