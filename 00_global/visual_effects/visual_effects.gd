# VisualEffects
extends Node

const DUST_EFFECT = preload("uid://c235umtfqtmho")
const HIT_PARTICLES = preload("uid://b4ig8f7ffjslo")

signal camera_shook( strength : float )
signal object_shook( strength : float )


# Create dust effects
func _create_dust_effect( pos : Vector2 ) -> DustEffect:
	var dust : DustEffect = DUST_EFFECT.instantiate()
	add_child( dust )
	dust.global_position = pos
	return dust


# Create jump dust
func jump_dust( pos : Vector2 ) -> void:
	var dust : DustEffect = _create_dust_effect( pos )
	dust.start( DustEffect.TYPE.JUMP )
	pass


# Create land dust
func land_dust( pos : Vector2 ) -> void:
	var dust : DustEffect = _create_dust_effect( pos )
	dust.start( DustEffect.TYPE.LAND )
	pass

# Create hit dust
func hit_dust( pos : Vector2 ) -> void:
	var dust : DustEffect = _create_dust_effect( pos )
	dust.start( DustEffect.TYPE.HIT )
	pass


func hit_particles( pos: Vector2, dir: Vector2, settings: HitParticleSettings ) -> void:
	var p: HitParticles = HIT_PARTICLES.instantiate()
	add_child( p )
	p.global_position = pos
	p.start( dir, settings )
	pass


func camera_shake( strength : float = 1.0 ) -> void:
	camera_shook.emit( strength )


func object_shake( strength : float = 1.0 ) -> void:
	object_shook.emit( strength )
	pass
