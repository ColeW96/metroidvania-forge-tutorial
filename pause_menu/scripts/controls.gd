class_name ControlsMenu extends Control

const GUI_INPUT_HINTS = preload("uid://doln5e7j65ibw")

@onready var move_inputs_container: HBoxContainer = %MoveInputsContainer

func _ready() -> void:
	var controller : String = "keyboard"
	var p : Player = get_tree().get_first_node_in_group("Player")
	if p:
		var input_hints : InputHints
		for c in p.get_children():
			if c is InputHints:
				input_hints = c
				break
	
		controller = input_hints.controller_type
	setup_move_inputs_container( controller )
	pass


func setup_move_inputs_container( controller : String ) -> void:
	var h_con : HBoxContainer = HBoxContainer.new()
	if controller != "keyboard":
		var hint1 : GuiInputHints = GUI_INPUT_HINTS.instantiate()
		hint1.hint = GuiInputHints.Hint.D_PAD
		h_con.add_child( hint1 )
		
		var label : Label = Label.new()
		label.text = "/"
		label.add_theme_font_size_override( "font_size", 10 )
		h_con.add_child(label)
		
		var hint2 : GuiInputHints = GUI_INPUT_HINTS.instantiate()
		hint2.hint = GuiInputHints.Hint.L_STICK
		h_con.add_child( hint2 )
	else:
		var hint1 : GuiInputHints = GUI_INPUT_HINTS.instantiate()
		hint1.hint = GuiInputHints.Hint.UP
		h_con.add_child( hint1 )
		
		var label : Label = Label.new()
		label.text = "/"
		label.add_theme_font_size_override( "font_size", 10 )
		h_con.add_child(label)
		
		var hint2 : GuiInputHints = GUI_INPUT_HINTS.instantiate()
		hint2.hint = GuiInputHints.Hint.DOWN
		h_con.add_child( hint2 )
		
		var label2 : Label = Label.new()
		label2.text = "/"
		label2.add_theme_font_size_override( "font_size", 10 )
		h_con.add_child(label2)
		
		var hint3 : GuiInputHints = GUI_INPUT_HINTS.instantiate()
		hint3.hint = GuiInputHints.Hint.LEFT
		h_con.add_child( hint3 )
		
		var label3 : Label = Label.new()
		label3.text = "/"
		label3.add_theme_font_size_override( "font_size", 10 )
		h_con.add_child(label3)
		
		var hint4 : GuiInputHints = GUI_INPUT_HINTS.instantiate()
		hint4.hint = GuiInputHints.Hint.RIGHT
		h_con.add_child( hint4 )
	
	move_inputs_container.add_child( h_con )
	pass
