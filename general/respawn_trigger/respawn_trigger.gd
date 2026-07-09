@tool
class_name RespawnTrigger extends Node2D

@export_range( 2, 12, 1, "or_greater" ) var size : int = 2 :
	set( value ):
		size = value
		apply_size()

@export var edge_offset : float = 24.0
@export var vertical_offset : float = 4.0

@onready var area_2d: Area2D = %Area2D


func _ready() -> void:
	if Engine.is_editor_hint():
		return
	apply_size()
	area_2d.body_entered.connect( _on_body_entered )
	pass


func _on_body_entered( n : Node2D ) -> void:
	if n is Player:
		respawn_player( n )
	pass


func respawn_player( p : Player ) -> void:
	var respawn_pos : Vector2 = p.last_position
	
	if p.edge_detected:
		respawn_pos.x -= p.last_floor_dir.x * edge_offset
	
	respawn_pos.y -= vertical_offset
	
	p.velocity = Vector2.ZERO
	p.global_position = respawn_pos
	p.edge_detected = false
	pass


func apply_size() -> void:
	area_2d = get_node_or_null( "Area2D" )
	if not area_2d:
		return
	scale.x = size
	pass
