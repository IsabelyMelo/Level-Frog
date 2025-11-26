extends Area2D

@export var speed: float = 600
@export var damage: int = 100
@export var fall_distance: float = 240.0  # distância total que vai se mover
@export var direction: Vector2 = Vector2(1.6, 1.0) # direita + baixo

var falling: bool = false
var start_position: Vector2
var target_position: Vector2

func _ready():
	# guarda a posição inicial
	start_position = position

	# garante que a direção esteja normalizada
	direction = direction.normalized()

	# calcula o ponto final (diagonal)
	target_position = start_position + direction * fall_distance

	# Detector detecta o player
	$Detector.connect("body_entered", _on_detector_body_entered)
	
	# se quiser que dê dano quando encostar, descomenta:
	# connect("body_entered", _on_body_entered)


func _physics_process(delta):
	if falling:
		# move na direção do alvo, com a velocidade definida
		position = position.move_toward(target_position, speed * delta)

		# quando chegar no alvo, para
		if position == target_position:
			falling = false


func _on_detector_body_entered(body):
	# Ativa a queda somente se for o player
	if body.is_in_group("Player"):
		falling = true


#func _on_body_entered(body):
#	if body.has_method("take_damage"):
#		body.take_damage(damage)
#		# queue_free()
