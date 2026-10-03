class_name EyeSwitch extends Node2D

signal activated
signal deactivated

@export var give_timer : bool = false
@export var timer : float = 0.0

var is_open : bool = false

@onready var damage_area: DamageArea = $DamageArea
@onready var sprite_2d: Sprite2D = %Sprite2D
@onready var animation_player: AnimationPlayer = %AnimationPlayer


func _ready() -> void:
	if SaveManager.persistent_data.get_or_add( unique_name(), "closed" ) == "open":
		set_open()
		animation_player.play("closed")
	else:
		damage_area.damage_taken.connect( _on_damage_taken )
		animation_player.play("opened")


func set_open() -> void:
	animation_player.play("closing")
	is_open = true
	if give_timer:
		damage_area.process_mode = Node.PROCESS_MODE_DISABLED
		await get_tree().create_timer( timer ).timeout
		damage_area.process_mode = Node.PROCESS_MODE_INHERIT
		animation_player.play_backwards("closing")
		is_open = false
		deactivated.emit()
	else:
		damage_area.queue_free()
	pass


func unique_name() -> String:
	var u_name : String = ResourceUID.path_to_uid( owner.scene_file_path )
	u_name += "/" + get_parent().name + "/" + name
	return u_name


func _on_damage_taken( _a : AttackArea ) -> void:
	if not give_timer:
		SaveManager.persistent_data[ unique_name() ] = "open"
	activated.emit()
	set_open()
	pass
