class_name ESNPBHJumpState
extends EnemyState

@export var jump_strength : float = 300.0
@export var move_speed : float = 200.0
@export var cooldown : float = 5.0

var dir : float = 1.0
var on_cooldown : bool = false

@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"


func enter() -> void:
	animation_player.play("jump")
	animation_player.pause()
	dir = 1.0
	if enemy.sprite.flip_h == true:
		dir = -1.0
	enemy.velocity.y = -jump_strength
	
	blackboard.can_decide = false
	on_cooldown = true
	pass


func re_enter() -> void:
	# what happens if the state is called again?
	pass


func exit() -> void:
	blackboard.can_decide = true
	run_cooldown()
	pass


func physics_update( _delta : float ) -> void:
	
	enemy.velocity.x = dir * move_speed
	set_jump_frame()
	if enemy.is_on_floor() and enemy.velocity.y > 0:
		blackboard.can_decide = true
	pass


func run_cooldown() -> void:
	await get_tree().create_timer( cooldown ).timeout
	on_cooldown = false
	pass


func can_jump() -> bool:
	if not on_cooldown:
		return true
	return false


func set_jump_frame() -> void:
	var frame: float = remap( enemy.velocity.y, -jump_strength, 0.0, 0.0, 0.5 )
	animation_player.seek( frame, true )
	pass
