class_name ESNPBHGroundSlam
extends EnemyState

const ENERGY_WAVE = preload("uid://bflycv8iwr643")
const ENERGY_BURST = preload("uid://domj6yk8l1t8x")


@export var cooldown : float = 5.0
@export var tween_pos_01 : Vector2 = Vector2.ZERO
@export var tween_pos_02 : Vector2 = Vector2.ZERO
@export var effect_color : Color

var on_cooldown : bool = false
var effect_time : float = 0.0
var effect_delay : float = 0.05

var target_x_pos : float = 0.0

@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@onready var damage_shape: CollisionShape2D = $"../../DamageArea/CollisionShape2D2"
@onready var sprite_2d: PlayerSprite = $"../../Sprite2D"

func enter() -> void:
	animation_player.play( "ground_slam" )
	blackboard.can_decide = false
	on_cooldown = true
	enemy.velocity = Vector2.ZERO
	enemy.affected_by_gravity = false
	
	damage_shape.disabled = true
	
	_update_target_x_pos()
	
	var t : Tween = create_tween()
	t.set_ease(Tween.EASE_IN_OUT)
	t.set_trans(Tween.TRANS_EXPO)
	
	t.tween_interval(0.4)
	
	# Slam 1
	t.tween_callback( _slam_tween )
	#t.tween_property( enemy, "global_position",
			#Vector2( target_x_pos, tween_pos_01.y ),
			#1.0 )
	#
	#t.tween_property( enemy, "global_position",
			#Vector2( target_x_pos, tween_pos_02.y ),
			#0.25 )
	
	t.tween_interval(0.35)
	t.tween_callback( _update_target_x_pos )
	
	# Slam 2 - 2.0 seconds into animation
	t.tween_callback( _slam_tween )
	#t.tween_property( enemy, "global_position",
			#Vector2( target_x_pos, tween_pos_01.y ),
			#1.0 )
	#
	#t.tween_property( enemy, "global_position",
			#Vector2( target_x_pos, tween_pos_02.y ),
			#0.25 )
	# 3.25s
	t.tween_interval(0.35)
	# 3.6s
	# Slam 3
	t.tween_property( enemy, "global_position", tween_pos_01, 0.5 )
	# 4.1s
	t.tween_property( enemy, "global_position", tween_pos_02, 0.2 )
	t.tween_callback( _emit_waves )
	# 4.3s
	t.tween_interval( 2.7 )
	#7.0s
	t.tween_callback( _on_tween_finished )
	pass


func re_enter() -> void:
	# what happens if the state is called again?
	pass


func exit() -> void:
	blackboard.can_decide = true
	enemy.affected_by_gravity = true
	damage_shape.disabled = false
	pass


func physics_update( delta : float ) -> void:
	effect_time -= delta
	if effect_time < 0:
		effect_time = effect_delay
		sprite_2d.ghost( effect_color, Color( .5, .5, 2, 0 ) )
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
	
	VisualEffects.camera_shake(10)
	pass


func _update_target_x_pos() -> void:
	target_x_pos = blackboard.target.global_position.x
	pass


func _slam_tween() -> void:
	var t : Tween = create_tween()
	_update_target_x_pos()
	
	t.tween_property( enemy, "global_position",
			Vector2( target_x_pos, tween_pos_01.y ),
			1.0 )
	
	t.tween_property( enemy, "global_position",
			Vector2( target_x_pos, tween_pos_02.y ),
			0.25 )
	pass
