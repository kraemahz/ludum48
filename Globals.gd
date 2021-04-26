extends Node


func _ready():
	OS.min_window_size = Vector2(1280, 960)
	OS.max_window_size = Vector2(1280, 960)

func load_new_scene(new_scene_path):
	get_tree().change_scene(new_scene_path)
