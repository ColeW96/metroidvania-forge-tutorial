class_name Spike extends Node2D

@export var movespeed : float = 200.0
var timer : float = 0.0

@onready var hazard_area: HazardArea = %HazardArea

func _ready() -> void:
	timer = 3.0
	hazard_area.damage_done.connect( _on_damage_done )
	pass


func _physics_process(delta: float) -> void:
	timer -= delta
	if timer <= 0:
		hazard_area.queue_free()
		queue_free()
	global_position.x += movespeed * delta
	pass


func _on_damage_done( result : bool ) -> void:
	if result:
		queue_free()
	pass
