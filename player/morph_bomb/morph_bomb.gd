class_name MorphBomb extends Node2D

var timer : float = 0

@onready var attack_area: AttackArea = %AttackArea
@onready var animation_player: AnimationPlayer = %AnimationPlayer

func _ready() -> void:
	timer = 1.3
	pass


func _process(delta: float) -> void:
	timer -= delta
	if timer <= 0:
		destroy()
	pass


func destroy() -> void:
	animation_player.play("explode")
	await animation_player.animation_finished
	queue_free()
	pass
