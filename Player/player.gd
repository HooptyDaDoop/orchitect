class_name Player extends CharacterBody2D


@onready var jump_buffer_timer: Timer = $Timers/JumpBufferTimer
@onready var harvester_tool: Harvester = $HarvesterTool
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D
@onready var harvest_cooldown_timer: Timer = $Timers/HarvestCooldownTimer

@export_group('Jumping')
## Height of the jump.[br]Defined in pixels.
@export var jump_height: float = 240
## Time to reach [param jump_height] from starting y position.[br]Defined in seconds.
@export var peak_time: float = 0.4
## Time to reach starting position from [param jump_height].[br]Defined in seconds.
@export var fall_time: float = 0.35

var jump_force: float
var up_gravity: float
var down_gravity: float

@export_subgroup('Accessibility')
@export var buffer_time: float = 0.25

@export_group('Movement')
@export var move_speed: float = 460
var move_direction: float = 0

@export_group('Harvesting')
@export var is_harvesting: bool = false
@export var harvest_damage: float = 1
@export var harvest_wait_time: float = 1


func _ready() -> void:
	jump_force = (2 * jump_height / peak_time) * -1
	up_gravity = (-2 * jump_height / pow(peak_time, 2)) * -1
	down_gravity = (-2 * jump_height / pow(fall_time, 2)) * -1

	jump_buffer_timer.wait_time = buffer_time

	harvester_tool.damage = harvest_damage
	harvest_cooldown_timer.wait_time = harvest_wait_time


func _process(_delta: float) -> void:
	move_direction = 0
	if Input.is_action_pressed('move_left'):
		move_direction -= 1
	if Input.is_action_pressed('move_right'):
		move_direction += 1

	var mouse_pos: Vector2 = get_global_mouse_position()

	if not is_on_floor():
		animation_player.speed_scale = 1
		animation_player.play('jump')
	else:
		if move_direction == 0:
			animation_player.speed_scale = 1
			animation_player.play('idle')
		else:
			animation_player.speed_scale = 2
			animation_player.play('walk')

	if move_direction < 0:
		sprite.flip_h = true
	elif move_direction > 0:
		sprite.flip_h = false

	if not is_harvesting:
		if mouse_pos.x < position.x:
			harvester_tool.flip_left()
		elif mouse_pos.x > position.x:
			harvester_tool.flip_right()

	if not is_harvesting and Input.is_action_just_pressed('attack') and harvest_cooldown_timer.is_stopped():
		harvester_tool.harvest()
		is_harvesting = true
		harvest_cooldown_timer.start()

	if Input.is_action_pressed('jump') and is_on_floor():
		velocity.y = jump_force
	if Input.is_action_just_pressed('jump') and not is_on_floor() and jump_buffer_timer.is_stopped():
		jump_buffer_timer.start()

	if is_on_floor() and not jump_buffer_timer.is_stopped():
		velocity.y = jump_force


func _physics_process(delta: float) -> void:
	velocity.y += _get_gravity(delta)
	velocity.x = move_direction * move_speed
	move_and_slide()


func _get_gravity(delta: float) -> float:
	if velocity.y < 0:
		return up_gravity * delta
	else:
		return down_gravity * delta


func _on_harvester_tool_on_harvest_done() -> void:
	is_harvesting = false
