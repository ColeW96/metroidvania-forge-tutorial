@icon( "res://general/icons/loot_drop.svg" )
class_name LootDropper extends Marker2D

@export var items : Array[ LootData ]

func _ready() -> void:
	if owner is Enemy:
		owner.was_killed.connect( _drop_loot )
	elif owner is Breakable:
		owner.destroyed.connect( _drop_loot )
	pass


func _drop_loot() -> void:
	for i in items:
		if i.drop_chance <= randf():
			continue
		var drop_scene = load( i.item )
		var count : int = randi_range( i.min_amount, i.max_amount )
		for j in count:
			var drop = drop_scene.instantiate()
			owner.add_sibling.call_deferred( drop )
			drop.global_position = global_position
			if drop is CharacterBody2D:
				drop.velocity = Vector2( randf_range( -50, 50 ), randf_range( -200, -400 ) )
	pass
