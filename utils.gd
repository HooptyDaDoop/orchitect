extends Node


func _input(event: InputEvent) -> void:
	if event.is_action('exit'):
		get_tree().quit()
