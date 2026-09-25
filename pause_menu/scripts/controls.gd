class_name ControlsMenu extends Control

const GUI_INPUT_HINTS = preload("uid://doln5e7j65ibw")

@export var move_inputs_container : HBoxContainer
@export var pan_inputs_container : HBoxContainer

func _ready() -> void:
	var controller : String = DeviceManager.controller_type
	setup_move_inputs_container( controller )
	setup_pan_inputs_container( controller )
	DeviceManager.device_changed.connect( _on_device_changed )
	pass


func setup_move_inputs_container( controller : String ) -> void:
	for c in move_inputs_container.get_children():
		c.queue_free()
	
	var move_label : Label = Label.new()
	move_label.text = "Move:"
	move_label.add_theme_font_size_override( "font_size", 12 )
	move_inputs_container.add_child(move_label)
	
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
		hint2.hint = GuiInputHints.Hint.LEFT
		h_con.add_child( hint2 )
		
		var label2 : Label = Label.new()
		label2.text = "/"
		label2.add_theme_font_size_override( "font_size", 10 )
		h_con.add_child(label2)
		
		var hint3 : GuiInputHints = GUI_INPUT_HINTS.instantiate()
		hint3.hint = GuiInputHints.Hint.DOWN
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


func setup_pan_inputs_container( controller : String ) -> void:
	for c in pan_inputs_container.get_children():
		c.queue_free()
	
	var pan_label : Label = Label.new()
	pan_label.text = "Camera:"
	pan_label.add_theme_font_size_override( "font_size", 12 )
	pan_inputs_container.add_child(pan_label)
	
	var h_con : HBoxContainer = HBoxContainer.new()
	if controller != "keyboard":
		var hint1 : GuiInputHints = GUI_INPUT_HINTS.instantiate()
		hint1.hint = GuiInputHints.Hint.R_STICK
		h_con.add_child( hint1 )
	else:
		var hint1 : GuiInputHints = GUI_INPUT_HINTS.instantiate()
		hint1.hint = GuiInputHints.Hint.PAN_UP
		h_con.add_child( hint1 )
		
		var label : Label = Label.new()
		label.text = "/"
		label.add_theme_font_size_override( "font_size", 10 )
		h_con.add_child(label)
		
		var hint2 : GuiInputHints = GUI_INPUT_HINTS.instantiate()
		hint2.hint = GuiInputHints.Hint.PAN_DOWN
		h_con.add_child( hint2 )
		
		var label2 : Label = Label.new()
		label2.text = "/"
		label2.add_theme_font_size_override( "font_size", 10 )
		h_con.add_child(label2)
		
		var hint3 : GuiInputHints = GUI_INPUT_HINTS.instantiate()
		hint3.hint = GuiInputHints.Hint.PAN_LEFT
		h_con.add_child( hint3 )
		
		var label3 : Label = Label.new()
		label3.text = "/"
		label3.add_theme_font_size_override( "font_size", 10 )
		h_con.add_child(label3)
		
		var hint4 : GuiInputHints = GUI_INPUT_HINTS.instantiate()
		hint4.hint = GuiInputHints.Hint.PAN_RIGHT
		h_con.add_child( hint4 )
	
	pan_inputs_container.add_child( h_con )
	pass


func _on_device_changed() -> void:
	var controller : String = DeviceManager.controller_type
	setup_move_inputs_container( controller )
	setup_pan_inputs_container( controller )
	pass
