class_name Bullet extends Node2D

var bullet_speed : float = 600
var move_direction : Vector2 = Vector2.RIGHT
var distance_moved : float = 0
var max_distance : float = 450

@onready var bullet_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_area: AttackArea = %AttackArea
@onready var area_2d: Area2D = $Area2D



func _ready() -> void:
	attack_area.set_active()
	attack_area.damage_done.connect( _on_damage_done )
	area_2d.body_entered.connect( _on_body_entered )
	pass

func _physics_process(delta: float) -> void:
	if move_direction.x < 0:
		bullet_sprite.flip_h = true
	elif move_direction.x > 0:
		bullet_sprite.flip_h = false
	var new_pos : Vector2 = global_position + move_direction * delta * bullet_speed
	distance_moved += global_position.distance_to( new_pos )
	global_position = new_pos
	if distance_moved > max_distance:
		queue_free()
		#reset_bullet()
	pass


func reset_bullet() -> void:
	distance_moved = 0.0
	visible = false
	set_physics_process( false )
	pass


func _on_damage_done( result : bool ) -> void:
	if result:
		queue_free()
		attack_area.set_active( false )
	pass


func _on_body_entered( node : Node2D ) -> void:
	if node.get_parent() is Breakable:
		return
	elif node is TileMapLayer:
		queue_free()
	pass
