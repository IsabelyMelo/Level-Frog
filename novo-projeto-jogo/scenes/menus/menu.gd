extends Control

func _ready() -> void:
	if not $start.pressed.is_connected(_on_start_pressed):
		$start.pressed.connect(_on_start_pressed)

	if not $exit.pressed.is_connected(_on_exit_pressed):
		$exit.pressed.connect(_on_exit_pressed)

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menus/levels-map.tscn")

func _on_exit_pressed() -> void:
	get_tree().quit()
