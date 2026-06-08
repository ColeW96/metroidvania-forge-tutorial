@icon( "res://general/icons/edge_sensor.svg" )
class_name EdgeSensor extends RayCast2D

signal edge_detected

var enemy : Enemy
var colliding : bool = true

func _ready() -> void:
	set_collision_mask_value(1, true)
	set_collision_mask_value(2, true)
	if owner is Enemy:
		enemy = owner
		enemy.direction_changed.connect( _on_direction_changed )
	else:
		set_physics_process( false )
		enabled = false
	pass


func _physics_process(_delta: float) -> void:
	if not enemy.is_on_floor():
		return
	
	var _is_colliding : bool = is_colliding()
	
	if colliding != _is_colliding:
		colliding = _is_colliding
		if not colliding:
			enemy.blackboard.edge_detected = true
			edge_detected.emit()
		else:
			enemy.blackboard.edge_detected = false
	pass


func _on_direction_changed( new_dir : float ) -> void:
	if new_dir < 0 and position.x > 0 or new_dir > 0 and position.x < 0:
		position.x *= -1
	pass
