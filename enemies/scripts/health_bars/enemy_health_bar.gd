class_name EnemyHealthBar extends Control

@onready var hp_bar: TextureProgressBar = %HPBar
@onready var hp_bar_highlight: TextureProgressBar = %HPBarHighlight

var hp_bar_tween : Tween

func _ready() -> void:
	visible = false
	hp_bar.value = 100
	hp_bar_highlight.value = 100
	pass


func show_health_bar() -> void:
	visible = true
	pass


func tween_hp_highlight( target_value : float ) -> void:
	if hp_bar_tween:
		hp_bar_tween.kill()
	
	hp_bar_tween = create_tween()
	hp_bar_tween.set_ease(Tween.EASE_OUT)
	hp_bar_tween.set_trans(Tween.TRANS_EXPO)
	hp_bar_tween.tween_interval( 0.5 )
	hp_bar_tween.tween_property( hp_bar_highlight, "value", target_value, 0.5 )
	pass


func update_health_bar( hp : float, max_hp : float ) -> void:
	var value : float = ( hp / max_hp ) * 100
	hp_bar.value = value
	tween_hp_highlight( value )
	pass
