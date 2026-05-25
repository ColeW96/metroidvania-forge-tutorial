class_name PlayerCamera extends Camera2D

var shake_strength : float = 0.0
@export var shake_decay_rate : float = 5.0
@export var max_shake_offset : float = 20.0


func _ready():
	VisualEffects.camera_shook.connect( _apply_shake )
	pass


func _process(delta):
	offset = Vector2(
			randf_range( -shake_strength, shake_strength ),
			randf_range( -shake_strength, shake_strength )
		)
	shake_strength = lerp( shake_strength, 0.0, shake_decay_rate * delta )
	pass


func _apply_shake( strength : float ) -> void:
	shake_strength = min( strength, max_shake_offset )
	pass
