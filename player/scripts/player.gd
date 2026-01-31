class_name Player extends CharacterBody2D

const DEBUG_JUMP_INDICATOR = preload("uid://bqucnd6ugb7r")
const BULLET = preload("uid://bdoia83dmojob")

#region /// on ready variables
@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_stand: CollisionShape2D = $CollisionStand
@onready var collision_crouch: CollisionShape2D = $CollisionCrouch
@onready var one_way_platform_shapecast: ShapeCast2D = $OneWayPlatformShapecast
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var bullet_spawn: Node2D = $BulletSpawn
#endregion


#region /// export variables
@export var move_speed : float = 150.0
@export var max_fall_velocity : float = 600.0
#endregion


#region /// State Machine Variables
var states : Array[ PlayerState ]
var current_state : PlayerState :
	get : return states.front()
var previous_state : PlayerState :
	get : return states[ 1 ]
#endregion


#region /// player stats
var hp : float = 20 :
	set( value ):
		hp = clampf( value, 0, max_hp )
		Messages.player_health_changed.emit( hp, max_hp )
var max_hp : float = 20 : 
	set( value ):
		max_hp = value
		Messages.player_health_changed.emit( hp, max_hp )
var dash : bool = false
var double_jump : bool = false
var ground_slam : bool = false
var morph_roll : bool = false
#endregion


#region /// standard variables
var direction : Vector2 = Vector2.ZERO
var _cardinal_direction : Vector2 = Vector2.RIGHT
var gravity : float = 980.0
var gravity_multiplier : float = 1.0
var bullet_spawn_pos : Vector2
var aiming_up : bool = false
#endregion


func _ready() -> void:
	if get_tree().get_first_node_in_group( "Player" ) != self:
		self.queue_free()
	initialize_states()
	self.call_deferred( "reparent", get_tree().root )
	bullet_spawn_pos = bullet_spawn.position
	Messages.player_healed.connect( _on_player_healed )
	Messages.back_to_title_screen.connect( queue_free )
	pass


func _unhandled_input( event: InputEvent ) -> void:
	if event.is_action_pressed( "action" ):
		Messages.player_interacted.emit( self )
	elif event.is_action_pressed( "pause" ):
		get_tree().paused = true
		var pause_menu : PauseMenu = load( "res://pause_menu/pause_menu.tscn" ).instantiate()
		add_child( pause_menu )
		return
	
	# DEBUG
	if OS.is_debug_build():
		if event is InputEventKey and event.is_pressed():
			if event.keycode == KEY_MINUS:
				if Input.is_key_pressed( KEY_SHIFT ):
					max_hp -= 10
				else:
					hp -= 2
			elif event.keycode == KEY_EQUAL:
				if Input.is_key_pressed( KEY_SHIFT ):
					max_hp += 10
				else:
					hp += 2
	# end DEBUG
	
	change_state( current_state.handle_input( event ) )
	pass


func _process( _delta: float ) -> void:
	update_direction()
	change_state( current_state.process( _delta ) )
	pass


func _physics_process( _delta: float ) -> void:
	velocity.y += gravity * _delta * gravity_multiplier
	velocity.y = clampf( velocity.y, -1000.0, max_fall_velocity )
	move_and_slide()
	change_state( current_state.physics_process( _delta ) )
	pass


func initialize_states() -> void:
	states = []
	for c in $States.get_children():
		if c is PlayerState:
			states.append( c )
			c.player = self
		pass
	
	if states.size() == 0:
		return
	
	for state in states:
		state.init()
	
	change_state( current_state )
	current_state.enter()
	$Label.text = current_state.name
	pass


func change_state( new_state : PlayerState ) -> void:
	if new_state == null:
		return
	elif new_state == current_state:
		return
	
	if current_state:
		current_state.exit()
	
	states.push_front( new_state )
	current_state.enter()
	
	states.resize( 3 )
	$Label.text = current_state.name
	pass


func update_direction() -> void:
	var prev_direction : Vector2 = direction
	
	var x_axis = Input.get_axis( "left", "right")
	var y_axis = Input.get_axis( "up", "down" )
	direction = Vector2( x_axis, y_axis )
	
	if prev_direction.x != direction.x:
		if direction.x < 0:
			sprite.flip_h = true
			_cardinal_direction = Vector2.LEFT
			bullet_spawn.position.x = -bullet_spawn_pos.x
		elif direction.x > 0:
			sprite.flip_h = false
			_cardinal_direction = Vector2.RIGHT
			bullet_spawn.position.x = bullet_spawn_pos.x
	pass


func add_debug_indicator( color : Color = Color.RED ) -> void:
	var d : Node2D = DEBUG_JUMP_INDICATOR.instantiate()
	get_tree().root.add_child( d )
	d.global_position = global_position
	d.modulate = color
	await get_tree().create_timer( 3 ).timeout
	d.queue_free()
	pass


func spawn_bullet() -> void:
	bullet_spawn.get_node("AnimatedSprite2D").play()
	var bullet : Bullet = BULLET.instantiate()
	get_tree().root.add_child( bullet )
	
	if aiming_up == true:
		var rotate_up : float = deg_to_rad( -90 )
		bullet.move_direction = Vector2.UP
		bullet.bullet_sprite.rotation = rotate_up
		bullet_spawn.get_node("AnimatedSprite2D").flip_h = false
	elif _cardinal_direction == Vector2.LEFT:
		bullet.move_direction = Vector2.LEFT
		bullet_spawn.get_node("AnimatedSprite2D").flip_h = true
	elif _cardinal_direction == Vector2.RIGHT:
		bullet_spawn.get_node("AnimatedSprite2D").flip_h = false
	
	if animation_player.current_animation == "run_shoot_up":
		var degrees_rotated : float = deg_to_rad( 25 )
		if _cardinal_direction == Vector2.LEFT:
			bullet.move_direction = bullet.move_direction.rotated( degrees_rotated )
			bullet.bullet_sprite.rotation = deg_to_rad( 43 )
		elif _cardinal_direction == Vector2.RIGHT:
			bullet.move_direction = bullet.move_direction.rotated( -degrees_rotated )
			bullet.bullet_sprite.rotation = deg_to_rad( -43 )
	
	bullet.global_position = bullet_spawn.global_position
	pass


func _on_player_healed( amount : float ) -> void:
	hp += amount
	# audio/visual
	pass
