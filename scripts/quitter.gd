extends Node

@export var quit_action: String

func _input(event):
	if quit_action != null and quit_action != "" and event.is_action_pressed(quit_action):
		get_tree().quit()
