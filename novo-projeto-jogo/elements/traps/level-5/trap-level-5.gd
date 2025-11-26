extends Area2D

@export var speed: float = 700
@export var damage: int = 100

var falling: bool = false

func _ready():
	# Detector detecta o player
	$Detector.connect("body_entered", _on_detector_body_entered)
	
	# Trap causa dano quando colide
	connect("body_entered", _on_body_entered)


func _physics_process(delta):
	if falling:
		position.y += speed * delta   # cai verticalmente


func _on_detector_body_entered(body):
	# Ativa a queda somente se for o player
	if body.is_in_group("Player"):
		falling = true


func _on_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(damage)
		#queue_free()
