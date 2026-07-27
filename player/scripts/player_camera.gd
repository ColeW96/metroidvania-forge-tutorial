class_name PlayerCamera extends Camera2D

var shake_strength : float = 0.0
var current_pan_offset : Vector2 = Vector2.ZERO
@export var shake_decay_rate : float = 5.0
@export var max_shake_offset : float = 20.0
@export var max_peek_distance: float = 100.0
@export var pan_speed: float = 8.0


func _ready():
	VisualEffects.camera_shook.connect( _apply_shake )
	pass


func _process(delta):
	_calculate_pan_offset(delta)
	
	var current_shake_offset = Vector2(
			randf_range( -shake_strength, shake_strength ),
			randf_range( -shake_strength, shake_strength )
		)
	shake_strength = lerp( shake_strength, 0.0, shake_decay_rate * delta )
	
	offset = current_pan_offset + current_shake_offset
	pass


func _apply_shake( strength : float ) -> void:
	shake_strength = min( strength, max_shake_offset )
	pass


func _calculate_pan_offset( delta : float ) -> void:
	var input_dir := Vector2.ZERO
	input_dir.x = Input.get_axis("camera_left", "camera_right")
	input_dir.y = Input.get_axis("camera_up", "camera_down")
	if input_dir.length() > 1.0:
		input_dir = input_dir.normalized()
		
	var target_offset = input_dir * max_peek_distance
	current_pan_offset = current_pan_offset.lerp(target_offset, pan_speed * delta)
	
	var half_view_size = (get_viewport_rect().size / zoom) / 2.0
	var min_cam_pos = Vector2(limit_left + half_view_size.x, limit_top + half_view_size.y)
	var max_cam_pos = Vector2(limit_right - half_view_size.x, limit_bottom - half_view_size.y)
	if min_cam_pos.x > max_cam_pos.x:
		max_cam_pos.x = min_cam_pos.x
	if min_cam_pos.y > max_cam_pos.y:
		max_cam_pos.y = min_cam_pos.y
		
	var natural_cam_center = global_position.clamp(min_cam_pos, max_cam_pos)
	var min_allowed_pan = min_cam_pos - natural_cam_center
	var max_allowed_pan = max_cam_pos - natural_cam_center
	current_pan_offset.x = clamp(current_pan_offset.x, min_allowed_pan.x, max_allowed_pan.x)
	current_pan_offset.y = clamp(current_pan_offset.y, min_allowed_pan.y, max_allowed_pan.y)
