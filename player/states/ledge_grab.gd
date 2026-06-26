class_name PlayerStateLedgeGrab extends PlayerState

var gravity : float
var jump_velocity : float = 450.0

func enter() -> void:
	player.grabbing_ledge = true
	player.animation_player.play("ledge_grab")
	player.jump_count = 0
	player.velocity = Vector2.ZERO
	gravity = player.gravity
	player.gravity = 0
	
	player.ledge_floor_check.force_raycast_update()
	if player.ledge_floor_check.is_colliding():
		var ledge_point : Vector2 = player.ledge_floor_check.get_collision_point()
		var snap_offset : Vector2 = ledge_point - player.ledge_grab_point.global_position
		var target_pos : Vector2 = player.global_position + snap_offset
		var tween : Tween = player.create_tween()
		tween.set_trans(Tween.TRANS_SINE)
		tween.set_ease(Tween.EASE_OUT)
		tween.tween_property( player, "global_position", target_pos, 0.05 )
	pass

func handle_input( event : InputEvent ) -> PlayerState:
	if event.is_action_pressed("jump"):
		player.velocity.y = -jump_velocity
		return jump
	if event.is_action_pressed("down"):
		_ease_player_drop()
		return fall
	return null


func exit() -> void:
	player.grabbing_ledge = false
	player.gravity = gravity
	pass


func _ease_player_drop() -> void:
	var target_x : float = player.global_position.x
	var target_y : float = player.global_position.y + 4
	var target_pos : Vector2 = Vector2( target_x, target_y )
	var tween : Tween = player.create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)
	if player._cardinal_direction == Vector2.RIGHT:
		target_pos.x -= 4
		tween.tween_property(player, "global_position", target_pos, 0.05 )
	else:
		target_pos.x += 4
		tween.tween_property(player, "global_position", target_pos, 0.05 )
	pass
