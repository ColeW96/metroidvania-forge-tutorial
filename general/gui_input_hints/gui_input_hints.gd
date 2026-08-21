@tool
class_name GuiInputHints extends TextureRect

enum Hint { ACTION, ATTACK, JUMP, DASH, SHOOT, DOWN, MORPH }
@export var hint : Hint = Hint.ACTION :
	set( value ):
		hint = value
		if Engine.is_editor_hint():
			set_input_hint_texture(hint)

const HINT_MAP : Dictionary = {
	"keyboard" : {
		"action" : 195,
		"attack" : 273,
		"jump" : 208,
		"dash" : 351,
		"shoot" : 286,
		"down" : 156,
		"morph" : 403
	},
	"playstation" : {
		"action" : 0,
		"attack" : 26,
		"jump" : 13,
		"dash" : 312,
		"shoot" : 39,
		"down" : 299,
		"morph" : 364
	},
	"xbox" : {
		"action" : 104,
		"attack" : 91,
		"jump" : 65,
		"dash" : 325,
		"shoot" : 78,
		"down" : 299,
		"morph" : 377
	},
	"switch" : {
		"action" : 247,
		"attack" : 260,
		"jump" : 234,
		"dash" : 338,
		"shoot" : 221,
		"down" : 299,
		"morph" : 390
	}
}

func _ready() -> void:
	set_input_hint_texture( hint )
	pass


func set_input_hint_texture( active_hint : Hint ) -> void:
	var controller : String = "keyboard"
	if not Engine.is_editor_hint():
		var p : Player = get_tree().get_first_node_in_group("Player")
		if p:
			var input_hints : InputHints
			for c in p.get_children():
				if c is InputHints:
					input_hints = c
					break
		
			controller = input_hints.controller_type
	
	# FOR DEBUGGING ONLY
	#controller = "xbox"
	
	var atlas_texture : AtlasTexture = texture as AtlasTexture
	if atlas_texture:
		var x : int = HINT_MAP[controller].get( get_hint_string(active_hint), 0 )
		atlas_texture.region = Rect2( x, 0, 13, 0 )
	pass


func get_hint_string( hint_enum : Hint ) -> String:
	var hint_string : String = ""
	match hint_enum:
		Hint.ACTION:
			hint_string = "action"
		Hint.ATTACK:
			hint_string = "attack"
		Hint.JUMP:
			hint_string = "jump"
		Hint.DASH:
			hint_string = "dash"
		Hint.SHOOT:
			hint_string = "shoot"
		Hint.DOWN:
			hint_string = "down"
		Hint.MORPH:
			hint_string = "morph"
	return hint_string
