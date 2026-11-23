extends Node

const BOOM = preload("uid://cf85is3e4o3kb")


@export var hp : float = 30.0
var max_hp : float

var follow_player : bool = false
var player : Player
var arm_og_position : Vector2

@onready var boss_battle_orchestrator: BossBattleOrchestrator = $".."
@onready var damage_area: DamageArea = $"../DamageArea"
@onready var exit_blocker: StaticBody2D = %ExitBlocker
@onready var anim_player: AnimationPlayer = $"../AnimationPlayer"
@onready var attack_anim_player: AnimationPlayer = $"../AttackAnimPlayer"
@onready var hand_sprite: Sprite2D = %HandSprite
@onready var arm_grab_sprite: Sprite2D = %ArmGrabSprite
@onready var arm_grab: Node2D = %ArmGrab


func _ready() -> void:
	max_hp = hp
	
	damage_area.damage_taken.connect( _on_damage_taken )
	boss_battle_orchestrator.battle_started.connect( _on_battle_started )
	anim_player.animation_finished.connect( _on_animation_finish )
	
	arm_og_position = arm_grab.global_position
	
	while not player:
		player = get_tree().get_first_node_in_group( "Player" )
		await get_tree().process_frame
	pass


func _physics_process(delta: float) -> void:
	if not follow_player or player == null:
		return
	
	var target_x : float = maxf(player.global_position.x + 123, 925)
	var weight : float = 1.0 - exp( -2.5 * delta )
	arm_grab.global_position.x = lerp( arm_grab.global_position.x, target_x, weight )
	pass


func _on_battle_started() -> void:
	anim_player.play("battle_start")
	pass


func _on_animation_finish( a : String ) -> void:
	if a == "battle_start":
		anim_player.play("idle")
		grab_attack()
	elif a == "defeat":
		exit_blocker.queue_free()
		boss_battle_orchestrator.end_boss_battle()
	pass


func _on_damage_taken( a : AttackArea ) -> void:
	hp -= a.damage
	
	if hp <= 0:
		damage_area.queue_free()
		anim_player.play("defeat")
		pass
	
	PlayerHud.update_boss_hp( hp, max_hp )
	pass


func grab_attack() -> void:
	if hp <= 0:
		return
	
	arm_grab.position = Vector2.ZERO
	attack_anim_player.play("attack")
	await attack_anim_player.animation_finished
	await get_tree().create_timer( randf_range( 3.0, 5.0 ) ).timeout
	grab_attack()
	pass


func return_arm() -> void:
	var t : Tween = create_tween()
	t.set_ease( Tween.EASE_IN_OUT )
	t.set_trans( Tween.TRANS_EXPO )
	t.tween_property( arm_grab, "global_position", arm_og_position, 0.4 )
	pass


func set_follow_player( value : bool = true ) -> void:
	follow_player = value
	pass


func shake_screen( magnitude : float = 10.0 ) -> void:
	VisualEffects.camera_shake( magnitude )
	Audio.play_spatial_sound( BOOM, hand_sprite.global_position, true )
	pass
