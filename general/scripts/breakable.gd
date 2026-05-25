@tool
@icon( "res://general/icons/breakable.svg" )
class_name Breakable extends Node2D

signal destroyed

@export var hp : float = 3.0
@export var fixed_hit_count : bool = false

@export_category( "Particles" )
@export var emission_offset : Vector2 = Vector2.ZERO
@export var hit_particles : Array[ HitParticleSettings ]
@export var destroy_particles : Array[ HitParticleSettings ]

@export_category( "Audio" )
@export var hit_audio : AudioStream = preload("uid://hfouy4mufw1c")
@export var destroy_audio : AudioStream = preload("uid://cpqpq5d0arguu")

var shake_strength : float = 0.0
@export var shake_decay_rate : float = 5.0
@export var max_shake_offset : float = 20.0


func _ready() -> void:
	if Engine.is_editor_hint():
		return
	for c in get_children():
		if c is DamageArea:
			c.damage_taken.connect( _on_damage_taken )
	pass


func _process(delta: float) -> void:
		for c in get_children():
			if c is Sprite2D:
				c.offset = Vector2(
						randf_range( -shake_strength, shake_strength ),
						randf_range( -shake_strength, shake_strength )
					)
				shake_strength = lerp( shake_strength, 0.0, shake_decay_rate * delta )


func _on_damage_taken( attack_area : AttackArea ) -> void:
	VisualEffects.object_shook.connect( _apply_shake )
	if fixed_hit_count:
		hp -= 1
	else:
		hp -= attack_area.damage
	
	var pos : Vector2 = global_position + emission_offset
	var dir : Vector2 = Vector2(1, -1)
	if attack_area.global_position.x > global_position.x:
		dir.x *= -1
		
	if hp > 0:
		Audio.play_spatial_sound( hit_audio, pos )
		for p in hit_particles:
			VisualEffects.hit_particles( pos, dir, p )
			VisualEffects.object_shake(2.0)
	else:
		Audio.play_spatial_sound( destroy_audio, pos )
		for p in destroy_particles:
			VisualEffects.hit_particles( pos, dir, p )
		for c in get_children():
			if c is DamageArea:
				c.make_invulnerable()
		clear_collision()
		var tween : Tween = create_tween()
		tween.tween_property( self, "modulate", Color( modulate, 0 ), 0.4 )
		await tween.finished
		queue_free()
		destroyed.emit()
	VisualEffects.object_shook.disconnect( _apply_shake )
	pass


func clear_collision() -> void:
	for c in get_children():
		if c is StaticBody2D:
			c.queue_free()
	pass


func _get_configuration_warnings() -> PackedStringArray:
	if _check_for_damage_area() == false:
		return ["Requires a DamageArea node"]
	else:
		return []


func _check_for_damage_area() -> bool:
	for c in get_children():
		if c is DamageArea:
			return true
	return false


func _apply_shake( strength : float ) -> void:
	shake_strength = min( strength, max_shake_offset )
	pass
