class_name Harvester extends Hitbox


@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var hit_sprite: Sprite2D = $CollisionShape2D/Sprite2D

@export var max_hit_sprite_scale_difference: float = 0.1


signal on_harvest_done()


func _ready() -> void:
	set_deferred('monitoring', false)
	set_deferred('monitorable', false)
	set_deferred('visible', false)


func harvest() -> void:
	randomize_hit_sprite()

	hit_sprite.visible = true
	animation_player.play('hit')

	await animation_player.animation_finished
	on_harvest_done.emit()

	animation_player.play('RESET')
	hit_sprite.visible = false


func flip_left() -> void:
	collision_shape.position.x = -96

func flip_right() -> void:
	collision_shape.position.x = 96


func randomize_hit_sprite() -> void:
	hit_sprite.rotation = randf_range(-PI, PI)
	hit_sprite.scale = Vector2(
		randf_range(0.5 - max_hit_sprite_scale_difference, 0.5 + max_hit_sprite_scale_difference),
		randf_range(0.5 - max_hit_sprite_scale_difference, 0.5 + max_hit_sprite_scale_difference),
	)
