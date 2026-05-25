# TestDummy
extends Node2D

@export var particles : Array[ HitParticleSettings ]
@export var base_wobble_angle : float = 4.0
@export var wobble_speed : float = 0.1
var wobble_count : int = 0
var tween : Tween

@onready var body_sprite: Sprite2D = $BodySprite
@onready var damage_area: DamageArea = $DamageArea


func _ready() -> void:
	damage_area.damage_taken.connect( _on_damage_taken )
	pass


func _on_damage_taken( attack_area : AttackArea ) -> void:
	var dir : float = 1.0
	if attack_area.global_position.x > global_position.x:
		dir = -1
	var pos : Vector2 = global_position + Vector2( 0, -30 )
	for p in particles:
		VisualEffects.hit_particles( pos, Vector2(dir, 0), p )
	wobble_count = 5
	wobble( dir )
	pass


func wobble( dir : float ) -> void:
	if tween:
		tween.kill()
	tween = create_tween()
	tween.set_ease( Tween.EASE_OUT )
	tween.set_trans( Tween.TRANS_QUAD )
	tween.tween_property(
		body_sprite,
		"rotation_degrees",
		base_wobble_angle * wobble_count * dir,
		wobble_speed * 0.5 )
	while wobble_count > 0:
		dir *= -1
		wobble_count -= 1
		tween.tween_property(
			body_sprite,
			"rotation_degrees",
			base_wobble_angle * wobble_count * dir,
			wobble_speed  )
	pass
