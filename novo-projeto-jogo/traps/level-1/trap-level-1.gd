extends Area2D

@export var speed: float = 200
@export var damage: int = 100
var direction := Vector2.ZERO

func _ready():
	connect("body_entered", _on_body_entered)

func _physics_process(delta):
	position += direction * speed * delta

func set_direction(dir: Vector2):
	direction = dir

func _on_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(damage)
	
	#queue_free()
