@tool
@icon( "res://general/icons/hidden_area.svg" )
class_name HiddenArea extends Node2D

enum SIDE { LEFT, RIGHT, TOP, BOTTOM }

@export_range( 1, 12, 1, "or_greater" ) var size : int = 1 :
	set( value ):
		size = value
		apply_area_settings()

@export var location : SIDE = SIDE.LEFT :
	set( value ):
		location = value
		apply_area_settings()


@onready var area_2d: Area2D = $Area2D


func _ready() -> void:
	if Engine.is_editor_hint():
		return
	for c in get_children():
		if c is TileMapLayer:
			c.visible = true
	apply_area_settings()
	area_2d.body_entered.connect( _on_body_entered )
	pass


func _on_body_entered( _node : Node2D ) -> void:
	var tween : Tween = create_tween()
	tween.tween_property( self, "modulate", Color(1, 1, 1, 0), 0.2 )
	await tween.finished
	queue_free()
	pass


func apply_area_settings() -> void:
	area_2d = get_node_or_null( "Area2D" )
	if not area_2d:
		return
	if location == SIDE.LEFT or location == SIDE.RIGHT:
		area_2d.scale.y = size
		if location == SIDE.LEFT:
			area_2d.scale.x = -1
		else:
			area_2d.scale.x = 1
	else:
		area_2d.scale.x = size
		if location == SIDE.TOP:
			area_2d.scale.y = 1
		else:
			area_2d.scale.y = -1
	pass
