@icon( "res://player/states/state.svg" )
class_name PlayerState extends Node

var player: Player
var next_state : PlayerState

#region /// state references
@onready var idle: PlayerStateIdle = %Idle
@onready var run: PlayerStateRun = %Run
@onready var jump: PlayerStateJump = %Jump
@onready var fall: PlayerStateFall = %Fall
@onready var crouch: PlayerStateCrouch = %Crouch
@onready var shoot: PlayerStateShoot = %Shoot
@onready var idle_shoot: PlayerStateIdleShoot = %Idle_Shoot
@onready var run_shoot: PlayerStateRunShoot = %Run_Shoot
@onready var crouch_shoot: PlayerStateCrouchShoot = %Crouch_Shoot
@onready var jump_shoot: PlayerStateJumpShoot = %Jump_shoot
@onready var fall_shoot: PlayerStateFallShoot = %Fall_Shoot
@onready var idle_shoot_up: PlayerStateIdleShootUp = %Idle_Shoot_Up
@onready var run_shoot_up: PlayerStateRunShootUp = %Run_Shoot_Up
@onready var shoot_up: PlayerStateShootUp = %Shoot_Up
#endregion


# What happens when this is initialized?
func init() -> void:
	pass


# What happens when we enter this state?
func enter() -> void:
	pass


# What happens when we exit this state?
func exit() -> void:
	pass


# What happens with input?
func handle_input( _event : InputEvent ) -> PlayerState:
	return next_state


# What happens each process tick in this state?
func process( _delta: float) -> PlayerState:
	return next_state


# What happens each physics process tick in this state?
func physics_process( _delta: float) -> PlayerState:
	return next_state
