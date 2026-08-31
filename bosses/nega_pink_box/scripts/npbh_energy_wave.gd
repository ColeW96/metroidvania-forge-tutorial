class_name NPBHEnergyWave extends Node2D

var move_speed : float = 400.0
var move_vector : Vector2 = Vector2.RIGHT
var facing_left : bool = false


func _ready() -> void:
	if facing_left:
		scale = Vector2(-1, 1)
		move_vector = Vector2.LEFT
	await get_tree().create_timer(5.0).timeout
	queue_free()
	pass


func _physics_process( delta: float ) -> void:
	global_position += move_vector * move_speed * delta
	pass
