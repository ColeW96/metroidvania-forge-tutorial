extends Sprite2D

#@onready var nega_pink_box_hero: Enemy = $"../.."


func _ready() -> void:
	visible = false
	var o = owner
	if o is Enemy:
		o.direction_changed.connect( _on_direction_changed )
	pass


func _on_direction_changed( new_dir : float ) -> void:
	if new_dir < 0:
		flip_h = true
		position.x = -24
	elif new_dir > 0:
		flip_h = false
		position.x = 24
	pass
