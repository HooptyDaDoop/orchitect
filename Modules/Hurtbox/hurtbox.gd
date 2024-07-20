class_name Hurtbox extends Area2D


@onready var grace_timer: Timer = $GraceTimer

@export var health: Health

@export_group('Settings')
@export var use_grace: bool = false
@export var grace_period: float = 1


var damager_hitbox: Hitbox = null


func _ready() -> void:
	grace_timer.wait_time = grace_period


func _on_area_entered(area: Hitbox) -> void:
	if area is not Hitbox: return

	if damager_hitbox != area:
		damager_hitbox = area
		try_take_damage()


func _on_area_exited(area: Hitbox) -> void:
	if area is not Hitbox: return

	if damager_hitbox == area:
		damager_hitbox = null


func _on_grace_timer_timeout() -> void:
	try_take_damage()


func try_take_damage() -> void:
	if damager_hitbox == null: return

	if use_grace:
		if not grace_timer.is_stopped():
			return
		health.take_damage(damager_hitbox.damage)
		grace_timer.start()
	else:
		health.take_damage(damager_hitbox.damage)
