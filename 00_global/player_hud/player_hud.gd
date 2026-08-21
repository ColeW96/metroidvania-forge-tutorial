# PlayerHud
extends CanvasLayer

@onready var hp_margin_container: MarginContainer = %HPMarginContainer
@onready var hp_bar: TextureProgressBar = %HPBar

@onready var game_over: Control = %GameOver
@onready var load_button: Button = %LoadButton
@onready var quit_button: Button = %QuitButton

@onready var boss_hp: Control = %BossHP
@onready var boss_hp_bar: ProgressBar = %BossHPBar
@onready var boss_hp_highlight: ProgressBar = %BossHPHighlight
@onready var boss_name: Label = %BossName
@onready var boss_hp_animation_player: AnimationPlayer = %BossHPAnimationPlayer

var boss_hp_tween : Tween


func _ready() -> void:
	Messages.player_health_changed.connect( update_health_bar )
	boss_hp.visible = false
	game_over.visible = false
	load_button.pressed.connect( _on_load_pressed )
	quit_button.pressed.connect( _on_quit_pressed )
	pass


func update_health_bar( hp : float, max_hp : float ) -> void:
	var value : float = ( hp / max_hp ) * 100
	hp_bar.value = value
	hp_margin_container.size.x = max_hp + 22
	pass


func show_game_over() -> void:
	load_button.visible = false
	quit_button.visible = false
	
	game_over.modulate.a = 0
	game_over.visible = true
	
	var tween : Tween = create_tween()
	tween.tween_property( game_over, "modulate", Color.WHITE, 3.0 )
	await tween.finished
	
	load_button.visible = true
	quit_button.visible = true
	
	load_button.grab_focus()
	pass


func clear_game_over() -> void:
	load_button.visible = false
	quit_button.visible = false
	await SceneManager.scene_entered
	game_over.visible = false
	var player : Player = get_tree().get_first_node_in_group("Player")
	player.queue_free()
	pass


func show_boss_hp( _n : String ) -> void:
	boss_hp_bar.value = 1.0
	boss_hp_highlight.value = 1.0
	boss_name.text = _n
	boss_hp_animation_player.play("show")
	pass


func update_boss_hp( hp : float, max_hp : float ) -> void:
	var new_value : float = hp / max_hp
	boss_hp_bar.value = new_value
	tween_hp_highlight( new_value )
	pass


func tween_hp_highlight( target_value : float ) -> void:
	if boss_hp_tween:
		boss_hp_tween.kill()
	
	boss_hp_tween = create_tween()
	boss_hp_tween.set_ease(Tween.EASE_OUT)
	boss_hp_tween.set_trans(Tween.TRANS_EXPO)
	boss_hp_tween.tween_interval( 0.5 )
	boss_hp_tween.tween_property( boss_hp_highlight, "value", target_value, 0.5 )
	pass


func hide_boss_hp() -> void:
	boss_hp_animation_player.play("hide")
	pass


func _on_load_pressed() -> void:
	SaveManager.load_game( SaveManager.current_slot )
	clear_game_over()
	pass


func _on_quit_pressed() -> void:
	SceneManager.transition_scene( "res://title_screen/title_screen.tscn", "", Vector2.ZERO, "up" )
	clear_game_over()
	pass
