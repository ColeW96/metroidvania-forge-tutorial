class_name UpgradeTab extends Control

const GUI_INPUT_HINTS = preload("uid://doln5e7j65ibw")

var player : Player

@export var upgrades : Array[ UpgradeButton ]
@export var upgrade_name : Label
@export var upgrade_description : VBoxContainer
@export var purchase_description : HBoxContainer
@export var upgrade_purchased : Label


func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	setup_upgrades()
	pass


func setup_upgrades() -> void:
	for b in upgrades:
		if b.ability_required != "":
			b.visible = player.has_ability( b.ability_required )
		b.disabled = player.upgrades.get( b.upgrade )
		if b.disabled == true:
			add_texture_rect_to_button( b )
		b.pressed.connect( _on_upgrade_pressed.bind(b) )
		b.focus_entered.connect( _on_upgrade_focus_entered.bind(b) )
		b.focus_exited.connect( _on_upgrade_focus_exited )
	pass


func _on_upgrade_pressed( b : UpgradeButton ) -> void:
	b.disabled = true
	purchase_description.visible = false
	upgrade_purchased.visible = true
	
	add_texture_rect_to_button(b)
	
	player.upgrades[b.upgrade] = true
	pass


func _on_upgrade_focus_entered( b : UpgradeButton ) -> void:
	display_upgrade(b)
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


# General upgrade display template
func display_upgrade( b : UpgradeButton ) -> void:
	upgrade_name.text = b.upgrade_name
	
	if b.description.size() > 0:
		populate_description( b )
	
	if b.description2 != "":
		populate_description2( b )
	
	if player:
		set_purchasing_text( player.upgrades[b.upgrade] )
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


func populate_description( b : UpgradeButton ) -> void:
	var h_con : HBoxContainer = HBoxContainer.new()
	for data in b.description:
		create_and_add_node(data, h_con)
	upgrade_description.add_child(h_con)
	pass


func populate_description2( b : UpgradeButton ) -> void:
	var label : Label = Label.new()
	label.text = b.description2
	label.add_theme_font_size_override( "font_size", 8 )
	upgrade_description.add_child(label)
	pass


func create_and_add_node( data : ControlData, container : HBoxContainer ) -> void:
	match data.type:
		ControlData.ControlType.LABEL:
			var label : Label = Label.new()
			label.text = data.label_text
			label.add_theme_font_size_override("font_size", data.font_size)
			container.add_child(label)
		ControlData.ControlType.GUI_INPUT_HINT:
			var hint : GuiInputHints = GUI_INPUT_HINTS.instantiate()
			hint.hint = data.hint_type
			container.add_child(hint)
	pass
