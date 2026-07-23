class_name PlaceholderBoss extends Sprite2D

signal boss_defeated

const SPIKE = preload("uid://k3rxlygqvubs")

@export var hp : float = 30
@onready var hazard_area: HazardArea = %HazardArea
@onready var damage_area: DamageArea = %DamageArea
@onready var spike_spawn_sprite: Sprite2D = %SpikeSpawnSprite

var spike_spawns : Array[ Marker2D ]

var timer : float = 0

func _ready() -> void:
	spike_spawn_sprite.visible = false
	for c in get_children():
		if c is Marker2D:
			spike_spawns.append( c )
	timer = 3.0
	damage_area.damage_taken.connect( _on_damage_taken )
	pass


func _physics_process(delta: float) -> void:
	timer -= delta
	if timer <= 0:
		do_attack()
		timer = 3.0
	pass


func _on_damage_taken( a : AttackArea ) -> void:
	hp -= a.damage
	if hp <= 0:
		boss_defeated.emit()
		destroy()
	pass


func destroy() -> void:
	hazard_area.queue_free()
	queue_free()
	pass


func do_attack() -> void:
	var spike : Spike = SPIKE.instantiate()
	var random_spawn : int = randi_range( 0, 2 )
	var spike_spawn : Marker2D = spike_spawns[random_spawn]
	spike_spawn_sprite.global_position = spike_spawn.global_position
	spike_spawn_sprite.visible = true
	await get_tree().create_timer(0.5).timeout
	spike_spawn_sprite.visible = false
	spike_spawn.add_child( spike )
	pass
