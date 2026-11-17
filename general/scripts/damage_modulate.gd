class_name DamageModulate extends Node

#@export var color : Color = Color(3.294, 3.294, 3.294, 1.0)
@export var color : Color = Color(3.061, 1.474, 0.884, 1.0)

@export_category("Optional Manual Assignments")
@export var damage_area : DamageArea
@export var modulate_targets : Array[Node2D]

var tween : Tween

func _ready() -> void:
	if damage_area:
		damage_area.damage_taken.connect( _modulate_node )
	elif owner is Enemy:
		owner.was_hit.connect( _modulate_node )
	else:
		for c in owner.get_children():
			if c is DamageArea:
				c.damage_taken.connect( _modulate_node )


func _modulate_node( _a : AttackArea ) -> void:
	if tween:
		tween.kill()
	
	tween = create_tween()
	
	if modulate_targets:
		tween.set_parallel(true)
		for t in modulate_targets:
			t.modulate = color
			tween.tween_property( t, "modulate", Color.WHITE, 0.2 )
	else:
		var sprite : Sprite2D = null
		for c in owner.get_children():
			if c is Sprite2D:
				sprite = c
				break
		
		sprite.modulate = color
		#owner.modulate = color
		tween.tween_property( sprite, "modulate", Color.WHITE, 0.2 )
	pass
