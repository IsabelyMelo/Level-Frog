extends Control

func _ready() -> void:
	for botao in get_children():
		if botao.name.begins_with("level_"):
			botao.modulate.a = 0.0 

func _on_level_1_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/levels/level-1.tscn")

func _on_level_2_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/levels/level-2.tscn")

func _on_level_3_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/levels/level-3.tscn")

func _on_exit_pressed() -> void:
	get_tree().quit()
