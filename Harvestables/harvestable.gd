class_name Harvestable extends CharacterBody2D


@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _take_hit() -> void:
	animation_player.play('hit')


func _on_health_on_damage(_amount: float, _current: float) -> void:
	_take_hit()


func _on_health_on_die() -> void:
	await animation_player.animation_finished
	queue_free()
