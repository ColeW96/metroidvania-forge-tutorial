@icon( "res://general/icons/input_hints.svg" )
class_name InputHints extends Node2D


const HINT_MAP : Dictionary = {
	"keyboard" : {
		"interact" : 15,
		"attack" : 10,
		"jump" : 16,
		"dash" : 11,
		"up" : 40
	},
	"playstation" : {
		"interact" : 0,
		"attack" : 2,
		"jump" : 1,
		"dash" : 3,
		"up" : 4
	},
	"xbox" : {
		"interact" : 8,
		"attack" : 7,
		"jump" : 5,
		"dash" : 6,
		"up" : 4
	},
	"switch" : {
		"interact" : 19,
		"attack" : 20,
		"jump" : 18,
		"dash" : 17,
		"up" : 4
	}
}

var controller_type : String = "keyboard"

@onready var sprite_2d: Sprite2D = $Sprite2D


func _ready() -> void:
	visible = false
	Messages.input_hint_changed.connect( _on_hint_changed )
	pass


func _on_hint_changed( hint : String ) -> void:
	if hint == "":
		visible = false
	else:
		visible = true
		controller_type = DeviceManager.controller_type
		sprite_2d.frame = HINT_MAP[ controller_type ].get( hint, "0" )
	pass
