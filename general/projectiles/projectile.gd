class_name Projectile extends CharacterBody2D

@export var horizontal_only : bool = false
@export var move_speed : float = 150.0
@export var lifetime : float = 5.0
@export_range( 0.0, 2.0, 0.05 ) var gravity_strength : float = 0.0

@export_category( "Audio" )
@export var spawn_audio : AudioStream
@export var destroy_audio : AudioStream

var gravity : float = 980.0
var target_position : Vector2
var animation_player : AnimationPlayer
var attack_area : AttackArea
var sprite : Sprite2D

func _ready() -> void:
	for c in get_children():
		if c is AttackArea:
			attack_area = c
			attack_area.set_active()
			attack_area.damage_done.connect( _on_damage_dealt )
		elif c is AnimationPlayer:
			animation_player = c
		elif c is Sprite2D:
			sprite = c
	_lifetime_timer()
	pass


func _physics_process(delta: float) -> void:
	velocity.y += gravity * gravity_strength * delta
	var col : KinematicCollision2D = move_and_collide( velocity * delta )
	if col:
		destroy()
	pass


func start( _target_position : Vector2 ) -> void:
	target_position = _target_position
	
	var g : float = gravity * gravity_strength
	var dist_x : float = target_position.x - global_position.x
	var dist_y : float = target_position.y - global_position.y
	
	velocity.x = sign( dist_x ) * move_speed
	
	var time : float = abs( dist_x ) / move_speed
	
	if horizontal_only:
		gravity_strength = 0.0
	else:
		velocity.y = ( dist_y - 0.5 * g * time * time ) / time
	
	if sprite and velocity.x < 0:
		sprite.flip_h = true
	
	if spawn_audio:
		Audio.play_spatial_sound( spawn_audio, global_position )
	pass


func _lifetime_timer() -> void:
	await get_tree().create_timer( lifetime ).timeout
	destroy()
	pass


func _on_damage_dealt( _result : bool ) -> void:
	destroy.call_deferred()
	pass


func destroy() -> void:
	velocity = Vector2.ZERO
	gravity_strength = 0.0
	
	if destroy_audio:
		Audio.play_spatial_sound( destroy_audio, global_position )
	
	if attack_area:
		attack_area.set_active( false )
	
	if animation_player:
		if animation_player.has_animation("destroy"):
			animation_player.play( "destroy" )
			await animation_player.animation_finished
	
	queue_free()
	pass
