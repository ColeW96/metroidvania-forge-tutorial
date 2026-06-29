class_name EnemyHealthBar extends Control

@onready var hp_bar: TextureProgressBar = %HPBar

func _ready() -> void:
	visible = false
	hp_bar.value = 100
	pass


func show_health_bar() -> void:
	visible = true
	pass


func update_health_bar( hp : float, max_hp : float ) -> void:
	var value : float = ( hp / max_hp ) * 100
	hp_bar.value = value
	pass
