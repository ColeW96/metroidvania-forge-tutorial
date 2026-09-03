class_name SlamWave extends Node2D

var move_speed : float = 200.0
var move_vector : Vector2 = Vector2.RIGHT
var facing_left : bool = false
var level : int = 1

@onready var area_2d: Area2D = %Area2D
@onready var ray_cast: RayCast2D = %RayCast2D
@onready var animation_player: AnimationPlayer = %AnimationPlayer


func _ready() -> void:
	if facing_left:
		scale = Vector2(-1, 1)
		move_vector = Vector2.LEFT
	if level == 3:
		animation_player.play("level_3")
	elif level == 2:
		animation_player.play("level_2")
	else:
		animation_player.play("level_1")
	area_2d.body_entered.connect( _on_body_entered )
	await get_tree().create_timer(.35).timeout
	queue_free()
	pass

func _process(_delta: float) -> void:
	if not ray_cast.is_colliding():
		queue_free()
	pass


func _physics_process(delta: float) -> void:
	global_position += move_vector * move_speed * delta
	pass


func _on_body_entered( _b : Node2D ) -> void:
	queue_free()
	pass
