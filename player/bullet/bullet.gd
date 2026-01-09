class_name Bullet extends Node2D

var bullet_speed : float = 600
var move_direction : Vector2 = Vector2.RIGHT
var distance_moved : float = 0
var max_distance : float = 450

@onready var bullet_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	if move_direction.x < 0:
		bullet_sprite.flip_h = true
	elif move_direction.x > 0:
		bullet_sprite.flip_h = false
	var new_pos : Vector2 = global_position + move_direction * delta * bullet_speed
	distance_moved += global_position.distance_to( new_pos )
	global_position = new_pos
	if distance_moved > max_distance:
		queue_free()
		#reset_bullet()
	pass


func reset_bullet() -> void:
	distance_moved = 0.0
	visible = false
	set_physics_process( false )
	pass
