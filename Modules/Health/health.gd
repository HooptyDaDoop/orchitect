class_name Health extends Node


@export var max_health: float
var current_health: float


signal on_damage(amount: float, current: float)
signal on_heal(amount: float, current: float)
signal on_die()


func _init() -> void:
	current_health = max_health


func take_damage(amount: float) -> void:
	current_health -= amount

	if current_health <= 0:
		current_health = 0
		on_die.emit()

	on_damage.emit(amount, current_health)


func heal(amount: float) -> void:
	current_health += amount

	if current_health > max_health:
		current_health = max_health

	on_heal.emit(amount, current_health)
