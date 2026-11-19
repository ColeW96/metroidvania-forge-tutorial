extends Node

const BOOM = preload("uid://cf85is3e4o3kb")


@export var hp : float = 30.0
var max_hp : float

@onready var boss_battle_orchestrator: BossBattleOrchestrator = $".."
@onready var damage_area: DamageArea = $"../DamageArea"
@onready var exit_blocker: StaticBody2D = %ExitBlocker
@onready var anim_player: AnimationPlayer = $"../AnimationPlayer"
@onready var hand_sprite: Sprite2D = %HandSprite
@onready var arm_grab_sprite: Sprite2D = %ArmGrabSprite

func _ready() -> void:
	max_hp = hp
	damage_area.damage_taken.connect( _on_damage_taken )
	boss_battle_orchestrator.battle_started.connect( _on_battle_started )
	anim_player.animation_finished.connect( _on_animation_finish )
	pass


func _on_battle_started() -> void:
	anim_player.play("battle_start")
	pass


func _on_animation_finish( a : String ) -> void:
	if a == "battle_start":
		anim_player.play("idle")
		# queue some attacks
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


func shake_screen( magnitude : float = 10.0 ) -> void:
	VisualEffects.camera_shake( magnitude )
	Audio.play_spatial_sound( BOOM, hand_sprite.global_position, true )
	pass
