@icon( "res://general/icons/enemy.svg" )
class_name PlaceholderBoss extends Sprite2D

signal boss_defeated

const SPIKE = preload("uid://k3rxlygqvubs")
const VOID_FIST = preload("uid://byc7a584ny4fi")


@export var hp : float = 30
@onready var hazard_area: HazardArea = %HazardArea
@onready var damage_area: DamageArea = %DamageArea
@onready var spike_spawn_sprite: Sprite2D = %SpikeSpawnSprite

var spike_spawns : Array[ Marker2D ]
var dir : Vector2 = Vector2.RIGHT
var timer : float = 0


func _ready() -> void:
	spike_spawn_sprite.visible = false
	for c in get_children():
		if c is Marker2D:
			spike_spawns.append( c )
	timer = 2.4
	damage_area.damage_taken.connect( _on_damage_taken )
	pass


func _physics_process(delta: float) -> void:
	update_dir()
	timer -= delta
	if timer <= 0:
		do_attack()
		timer = 2.4
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
	#var spike : Spike = SPIKE.instantiate()
	var void_fist : VoidFist = VOID_FIST.instantiate()
	var random_spawn : int = randi_range( 0, 2 )
	var spike_spawn : Marker2D = spike_spawns[random_spawn]
	spike_spawn_sprite.global_position = spike_spawn.global_position
	spike_spawn_sprite.visible = true
	$SpikeSpawnSprite/AnimationPlayer.play("default")
	await get_tree().create_timer(0.5).timeout
	#spike_spawn.add_sibling( void_fist )
	get_tree().root.add_child( void_fist )
	void_fist.global_position = spike_spawn.global_position
	void_fist.dir = dir
	if void_fist.dir == Vector2.LEFT:
		void_fist.scale.x *= -1
	spike_spawn_sprite.visible = false
	pass


func update_dir() -> void:
	var player = get_tree().get_first_node_in_group("Player")
	if not player:
		return
	if global_position.x < player.global_position.x:
		dir = Vector2.RIGHT
		scale.x = 1
	elif global_position.x > player.global_position.x:
		dir = Vector2.LEFT
		scale.x = -1
	pass
