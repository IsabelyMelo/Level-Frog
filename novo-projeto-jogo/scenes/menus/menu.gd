extends Control
@onready var menu_select_fx: AudioStreamPlayer = $menu_select_fx

func _ready() -> void:
	if not $start.pressed.is_connected(_on_start_pressed):
		$start.pressed.connect(_on_start_pressed)

	if not $exit.pressed.is_connected(_on_exit_pressed):
		$exit.pressed.connect(_on_exit_pressed)

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menus/levels-map.tscn")

func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_exit_mouse_entered() -> void:
	_select_effect()


func _on_start_mouse_entered() -> void:
	_select_effect()

func _select_effect() ->void:
	$menu_select_fx.stop()
	$menu_select_fx.play()
