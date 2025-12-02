extends Area2D

@export var next_scene_path: String = "res://scenes/menus/levels-map.tscn"

var _changing := false
@onready var collect_fx: AudioStreamPlayer = $collect_fx

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if _changing:
		return
	if body.is_in_group("Player"):
		collect_fx.play()
		await get_tree().create_timer(0.2).timeout
		_changing = true
		set_deferred("monitoring", false)              # << evita reentradas sem violar o passo de física
		if has_node("CollisionShape2D"):
			$CollisionShape2D.set_deferred("disabled", true)  # opcional, garante 1 único disparo
		call_deferred("_change_scene")                 # << troca de cena fora do callback

func _change_scene() -> void:
	get_tree().change_scene_to_file(next_scene_path)
