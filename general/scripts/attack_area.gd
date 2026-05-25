@icon("res://general/icons/attack_area.svg")
class_name AttackArea extends Area2D

@export var damage : float = 1.0


func _ready() :
	body_entered.connect( _on_body_entered )
	area_entered.connect( _on_body_entered )
	visible = false
	monitorable = false
	monitoring = false
	pass


func _on_body_entered( body : Node2D ) -> void:
	if body is DamageArea:
		body.take_damage(self)
		var pos : Vector2 = global_position
		pos.x = body.global_position.x
		VisualEffects.hit_dust( pos )
		pass
	pass


func activate( duration : float = 0.1 ) -> void:
	set_active()
	await get_tree().create_timer( duration ).timeout
	set_active(false)
	pass


func set_active( value : bool = true ) -> void:
	monitoring = value
	visible = value
	pass


func flip( direction_x : float ) -> void:
	if direction_x > 0:
		scale.x = 1
	elif direction_x < 0:
		scale.x = -1
	pass
