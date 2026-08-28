class_name MorphRollTab extends Control

const GUI_INPUT_HINTS = preload("uid://doln5e7j65ibw")

var player : Player


@onready var bombs: Button = %Bombs
@onready var upgrade_name: Label = %UpgradeName5
@onready var upgrade_description: VBoxContainer = %UpgradeDescription5
@onready var purchase_description: HBoxContainer = %PurchaseDescription5
@onready var upgrade_purchased: Label = %UpgradePurchased5



func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	setup_upgrades()
	pass


func setup_upgrades() -> void:
	bombs.disabled = player.bombs
	if bombs.disabled == true:
		add_texture_rect_to_button( bombs )
	bombs.pressed.connect( _on_upgrade_pressed.bind(bombs) )
	bombs.focus_entered.connect( _on_upgrade_focus_entered.bind("bombs") )
	bombs.focus_exited.connect( _on_upgrade_focus_exited )
	
	# more connections and setup go here
	pass


func _on_upgrade_pressed( b : Button ) -> void:
	b.disabled = true
	purchase_description.visible = false
	upgrade_purchased.visible = true
	
	add_texture_rect_to_button(b)
	
	if b.name == "Bombs":
		player.bombs = true
	# more upgrade checks go here
	# elif ...
	
	pass


func _on_upgrade_focus_entered( upgrade_name_str : String ) -> void:
	if upgrade_name_str == "bombs":
		display_bombs()
	#elif upgrade_name_str == "placeholder":
		#display_upgrade()
	pass


func _on_upgrade_focus_exited() -> void:
	for c in upgrade_description.get_children():
		if c:
			c.queue_free()
	
	purchase_description.visible = false
	upgrade_purchased.visible = false
	upgrade_name.text = ""
	pass


func add_texture_rect_to_button( b : Button ) -> void:
	var texture_rect : TextureRect = TextureRect.new()
	
	var gradient : Gradient = Gradient.new()
	gradient.colors = PackedColorArray( [Color(0.8, 0.969, 0.906), Color(0.8, 0.969, 0.906)] )
	gradient.offsets = PackedFloat32Array([0.0, 1.0])
	
	var gradient_texture : GradientTexture2D = GradientTexture2D.new()
	gradient_texture.gradient = gradient
	gradient_texture.width = 4
	gradient_texture.height = 4
	gradient_texture.fill = GradientTexture2D.FILL_LINEAR
	
	texture_rect.texture = gradient_texture
	
	b.add_child( texture_rect )
	
	texture_rect.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	pass


func display_bombs() -> void:
	upgrade_name.text = "Bombs"
	
	var hbox_con : HBoxContainer = HBoxContainer.new()
	
	var label : Label = Label.new()
	label.text = "Press"
	label.add_theme_font_size_override( "font_size", 8 )
	hbox_con.add_child( label )
	
	var hint : GuiInputHints = GUI_INPUT_HINTS.instantiate()
	hint.hint = hint.Hint.SHOOT
	hbox_con.add_child( hint )
	
	var label2 : Label = Label.new()
	label2.text = "while transformed to lay a bomb."
	label2.add_theme_font_size_override( "font_size", 8 )
	hbox_con.add_child( label2 )
	
	upgrade_description.add_child( hbox_con )
	
	if player:
		set_purchasing_text( player.bombs )
	pass


# General upgrade display template
func display_upgrade() -> void:
	# Set name of the upgrade to display
	upgrade_name.text = "Placeholder"
	
	# Example of adding a child to the upgrade_description
	var label : Label = Label.new()
	label.text = "This is a placeholder upgrade."
	label.add_theme_font_size_override( "font_size", 8 )
	
	upgrade_description.add_child( label )
	
	# Defensive check to display
	if player:
		# Replace player.placeholder_upgrade with actual player boolean
		#set_purchasing_text( player.placeholder_upgrade )
		pass
	pass


func set_purchasing_text( player_upgrade : bool ) -> void:
	if player_upgrade:
		purchase_description.visible = false
		upgrade_purchased.visible = true
	else:
		purchase_description.visible = true
		upgrade_purchased.visible = false
	pass
