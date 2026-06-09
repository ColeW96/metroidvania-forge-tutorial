@icon( "res://general/icons/player_sensor.svg" )
class_name PlayerSensor extends Area2D

signal player_entered
signal player_exited
signal started_searching

@export var search_duration : float = 2.0

var enemy : Enemy
var timer : float = 0.0


func _ready() -> void:
	set_collision_layer_value(1, false)
	set_collision_mask_value(1, false)
	if owner is Enemy:
		enemy = owner
		set_collision_mask_value(5, true)
		body_entered.connect( _on_body_entered )
		body_exited.connect( _on_body_exited )
		enemy.direction_changed.connect( _on_direction_changed )
	pass


func _physics_process(delta: float) -> void:
	if timer > 0:
		timer -= delta
		if timer <= 0:
			player_exited.emit()
			enemy.blackboard.target = null
	pass


func _on_body_entered( n : Node2D ) -> void:
	player_entered.emit()
	enemy.blackboard.target = n
	pass


func _on_body_exited( _n : Node2D ) -> void:
	started_searching.emit()
	timer = search_duration
	pass


func _on_direction_changed( dir : float ) -> void:
	if dir < 0:
		scale.x = -1
	elif dir > 0:
		scale.x = 1
	pass
