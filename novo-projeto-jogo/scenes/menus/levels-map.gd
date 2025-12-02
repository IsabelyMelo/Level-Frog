extends Control
@onready var select_fase_fx: AudioStreamPlayer = $select_fase_fx
@onready var menu_exit_fx: AudioStreamPlayer = $menu_exit_fx

func _ready() -> void:
	for botao in get_children():
		if botao.name.begins_with("level_"):
			botao.modulate.a = 0.0 
			

func _on_exit_pressed() -> void:
	get_tree().quit()
	
func _on_level_1_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/levels/level-1.tscn")

func _on_level_2_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/levels/level-2.tscn")

func _on_level_3_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/levels/level-3.tscn")

func _on_level_4_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/levels/level-4.tscn")

func _on_level_5_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/levels/level-5.tscn")

func _on_level_1_mouse_entered() -> void:
	_select_effect()

func _on_level_2_mouse_entered() -> void:
	_select_effect()

func _on_level_3_mouse_entered() -> void:
	_select_effect()

func _on_level_4_mouse_entered() -> void:
	_select_effect()

func _on_level_5_mouse_entered() -> void:
	_select_effect()
	
func _select_effect() ->void:
	$select_fase_fx.stop()
	$select_fase_fx.play()


func _on_exit_mouse_entered() -> void:
	$menu_exit_fx.stop()
	$menu_exit_fx.play()
