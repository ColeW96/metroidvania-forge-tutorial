@icon( "uid://dnpe3u7tde3r0" )
class_name SavePoint extends Node2D


@onready var area_2d: Area2D = $Area2D
@onready var animation_player: AnimationPlayer = $Node2D/AnimationPlayer


func _ready() -> void:
	area_2d.body_entered.connect( _on_player_entered )
	area_2d.body_exited.connect( _on_player_exited )
	pass


func _on_player_entered( _n : Node2D ) -> void:
	Messages.player_interacted.connect( _on_player_interacted )
	Messages.input_hint_changed.emit( "interact" )
	pass


func _on_player_exited( _n : Node2D ) -> void:
	Messages.player_interacted.disconnect( _on_player_interacted )
	Messages.input_hint_changed.emit( "" )
	pass


func _on_player_interacted( _player : Player ) -> void:
	Messages.player_healed.emit( 999 )
	SaveManager.save_game()
	animation_player.play("game_saved")
	animation_player.seek(0)
	Audio.ui_success()
	pass
