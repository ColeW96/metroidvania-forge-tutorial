class_name DustEffect extends Sprite2D

enum TYPE { JUMP, LAND, HIT }
@onready var animation_player: AnimationPlayer = $AnimationPlayer



func start( type : TYPE ) -> void:
	var anim_name : String = "jump"
	match type:
		TYPE.JUMP:
			position.y -= 14
		TYPE.LAND:
			anim_name = "land"
			position.y -= 14
		TYPE.HIT:
			anim_name = "hit"
			rotation_degrees = randi_range( 0, 3 ) * 90
	animation_player.play(anim_name)
	await animation_player.animation_finished
	queue_free()
	pass
