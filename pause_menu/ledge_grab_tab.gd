# LedgeGrabTab
extends Control

const GUI_INPUT_HINTS = preload("uid://doln5e7j65ibw")

@onready var morph_ascend: Button = %MorphAscend
@onready var upgrade: Button = %Upgrade
@onready var upgrade_name: Label = %UpgradeName
@onready var upgrade_description: VBoxContainer = %UpgradeDescription
@onready var purchase_description: HBoxContainer = %PurchaseDescription
@onready var upgrade_purchased: Label = %UpgradePurchased


func _ready() -> void:
	morph_ascend.pressed.connect( _on_upgrade_pressed.bind(morph_ascend) )
	morph_ascend.focus_entered.connect( _on_upgrade_focus_entered.bind("morph_ascend") )
	morph_ascend.focus_exited.connect( _on_upgrade_focus_exited )
	upgrade.focus_entered.connect( _on_upgrade_focus_entered.bind("placeholder") )
	pass


func _on_upgrade_pressed( b : Button ) -> void:

	pass


func _on_upgrade_focus_entered( upgrade_name_str : String ) -> void:
	if upgrade_name_str == "morph_ascend":
		display_morph_ascend()
	elif upgrade_name_str == "placeholder":
		display_upgrade()
	pass


func _on_upgrade_focus_exited() -> void:
	for c in upgrade_description.get_children():
		if c:
			c.queue_free()
	pass


func display_morph_ascend() -> void:
	upgrade_name.text = "Morph Ascend"
	
	var hbox_con : HBoxContainer = HBoxContainer.new()
	
	var label : Label = Label.new()
	label.text = "Press"
	label.add_theme_font_size_override( "font_size", 8 )
	hbox_con.add_child( label )
	
	var hint : GuiInputHints = GUI_INPUT_HINTS.instantiate()
	hint.hint = hint.Hint.MORPH
	hbox_con.add_child( hint )
	
	var label2 : Label = Label.new()
	label2.text = "while hanging to transform"
	label2.add_theme_font_size_override( "font_size", 8 )
	hbox_con.add_child( label2 )
	
	upgrade_description.add_child( hbox_con )
	
	var label3 : Label = Label.new()
	label3.text = "and ascend a ledge."
	label3.add_theme_font_size_override( "font_size", 8 )
	
	upgrade_description.add_child( label3 )
	pass


func display_upgrade() -> void:
	upgrade_name.text = "Placeholder"
	pass
