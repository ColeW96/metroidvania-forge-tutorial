class_name ESNPBHPlatformAttack
extends EnemyState

const ENERGY_BURST = preload("uid://domj6yk8l1t8x")

@export var cooldown : float = 5.0
@export var y_pos_01 : float = 527.0
@export var y_pos_02 : float = 656.0
@export var y_pos_03 : float = 265.0
@export var y_pos_04 : float = 452.0

@export var effect_color : Color
var effect_time : float = 0.0
var effect_delay : float = 0.05

var on_cooldown : bool = false

@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@onready var damage_shape: CollisionShape2D = $"../../DamageArea/CollisionShape2D2"
@onready var sprite_2d: PlayerSprite = $"../../Sprite2D"

func enter() -> void:
	animation_player.play( "platform_attack_start" )
	blackboard.can_decide = false
	on_cooldown = true
	enemy.velocity = Vector2.ZERO
	enemy.affected_by_gravity = false
	damage_shape.disabled = true
	
	var x_pos : float = enemy.global_position.x
	
	var t : Tween = create_tween()
	t.set_ease(Tween.EASE_IN_OUT)
	t.set_trans(Tween.TRANS_EXPO)
	
	t.tween_interval(0.3)
	
	t.tween_property(
		enemy, "global_position",
		Vector2(x_pos, y_pos_01),
		0.7 )
	
	t.tween_callback( _change_animation ) # changing to middle animation
	
	t.set_ease(Tween.EASE_IN)
	t.set_trans(Tween.TRANS_CUBIC)
	
	t.tween_property(
		enemy, "global_position",
		Vector2(x_pos, y_pos_02),
		0.5 )
	
	t.tween_callback( _move_enemy_to_top )
	
	t.tween_property(
		enemy, "global_position",
		Vector2(x_pos, y_pos_04),
		0.5 )
	
	t.tween_callback( _change_animation ) # changing to end animation
	t.tween_callback( _emit_waves )
	
	t.tween_interval( 0.6 )
	
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
	
	VisualEffects.camera_shake(10)
	pass


func _change_animation() -> void:
	if animation_player.current_animation == "platform_attack_start":
		animation_player.play("platform_attack_middle")
	elif animation_player.current_animation == "platform_attack_middle":
		animation_player.play("platform_attack_end")
	pass


func _move_enemy_to_top() -> void:
	enemy.global_position.y = y_pos_03
	pass
