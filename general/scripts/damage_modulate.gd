class_name DamageModulate extends Node

@export var color : Color = Color(3.294, 3.294, 3.294, 1.0)
var tween : Tween

func _ready() -> void:
	if owner is Enemy:
		owner.was_hit.connect( _modulate_node )
	else:
		for c in owner.get_children():
			if c is DamageArea:
				c.damage_taken.connect( _modulate_node )


func _modulate_node( _a : AttackArea ) -> void:
	if tween:
		tween.kill()
	var sprite : Sprite2D = null
	for c in owner.get_children():
		if c is Sprite2D:
			sprite = c
			break
	sprite.modulate = color
	#owner.modulate = color
	tween = create_tween()
	tween.tween_property( sprite, "modulate", Color.WHITE, 0.2 )
	pass
