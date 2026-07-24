class_name VoidFist extends Node2D

@export var movespeed : float = 200.0
var timer : float = 0.0
var dir : Vector2 = Vector2.RIGHT

@onready var hazard_area: HazardArea = %HazardArea
@onready var sprite_2d: Sprite2D = %Sprite2D

func _ready() -> void:
	timer = 2.0
	hazard_area.damage_done.connect( _on_damage_done )
	pass


func _physics_process(delta: float) -> void:
	timer -= delta
	if timer <= 0:
		hazard_area.queue_free()
		queue_free()
	global_position.x +=  (dir.x * movespeed) * delta
	pass


func _on_damage_done( result : bool ) -> void:
	if result:
		queue_free()
	pass
