@tool
@icon( "res://general/icons/patrol_limit.svg" )
class_name PatrolLimit extends Node2D

const PATROL_LIMIT = preload("uid://rjcyt4c02tvn")

@export var side : Side = Side.SIDE_LEFT :
	set( value ):
		side = value
		_add_sprite()


func _ready() -> void:
	if Engine.is_editor_hint():
		_add_sprite()
		return
	queue_free()
	pass


func _add_sprite() -> void:
	if get_child_count() > 0:
		for c in get_children():
			c.queue_free()
	
	var sprite : Sprite2D = Sprite2D.new()
	add_child( sprite )
	sprite.texture = PATROL_LIMIT
	sprite.position = Vector2( 0, -16 )
	
	var label : Label = Label.new()
	add_child( label )
	label.size.x = 32
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.position = Vector2( -16, -24 )
	
	if side == Side.SIDE_LEFT:
		sprite.modulate = Color.WHITE
		label.modulate = Color(0.2, 0.2, 0.2)
		label.text = "L"
	else:
		sprite.modulate = Color.INDIAN_RED
		label.modulate = Color.WHITE
		label.text = "R"
	pass
