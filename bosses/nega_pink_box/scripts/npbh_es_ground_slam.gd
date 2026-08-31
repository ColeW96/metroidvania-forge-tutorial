class_name ESNPBHGroundSlam
extends EnemyState

const ENERGY_WAVE = preload("uid://bflycv8iwr643")
const ENERGY_BURST = preload("uid://domj6yk8l1t8x")


@export var cooldown : float = 5.0
@export var tween_pos_01 : Vector2 = Vector2.ZERO
@export var tween_pos_02 : Vector2 = Vector2.ZERO

var on_cooldown : bool = false

@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"


func enter() -> void:
	animation_player.play( "ground_slam" )
	blackboard.can_decide = false
	on_cooldown = true
	enemy.velocity = Vector2.ZERO
	enemy.affected_by_gravity = false
	
	var t : Tween = create_tween()
	t.set_ease(Tween.EASE_IN_OUT)
	t.set_trans(Tween.TRANS_EXPO)
	t.tween_property( enemy, "global_position", tween_pos_01, 1.0 )
	
	t.tween_interval(1.2)
	
	t.set_ease(Tween.EASE_OUT)
	t.set_trans(Tween.TRANS_CUBIC)
	t.tween_property( enemy, "global_position", tween_pos_02, 0.25 )
	
	t.tween_callback( _emit_waves )
	
	t.tween_interval( 0.12 )
	
	t.tween_callback( _on_tween_finished )
	pass


func re_enter() -> void:
	# what happens if the state is called again?
	pass


func exit() -> void:
	blackboard.can_decide = true
	enemy.affected_by_gravity = true
	pass


func physics_update( _delta : float ) -> void:
	
	pass


func run_cooldown() -> void:
	await get_tree().create_timer( cooldown ).timeout
	on_cooldown = false
	pass


func _on_tween_finished() -> void:
	run_cooldown()
	blackboard.can_decide = true
	pass


func _emit_waves() -> void:
	var b : Node2D = ENERGY_BURST.instantiate()
	enemy.add_sibling(b)
	b.global_position = enemy.global_position
	
	var e : NPBHEnergyWave = ENERGY_WAVE.instantiate()
	enemy.add_sibling(e)
	e.global_position = enemy.global_position
	
	var e2 : NPBHEnergyWave = ENERGY_WAVE.instantiate()
	e2.facing_left = true
	enemy.add_sibling(e2)
	e2.global_position = enemy.global_position
	pass
