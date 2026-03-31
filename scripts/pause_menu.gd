extends Control

@onready var root = $".."

func _on_resume_button_up() -> void:
	root.pause()

func _on_quit_button_up() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
