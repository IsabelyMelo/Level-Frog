extends Area2D

@export var damage: int = 100
@export var speed: float = 290.0        # Velocidade do movimento
@export var move_distance: float = 1050.0 # Distância que ele vai percorrer horizontalmente
@export var wait_time: float = 3.0      # Tempo de espera antes de voltar

var start_position: Vector2
var target_position: Vector2
# Estados: "IDLE" (parado), "GOING" (indo), "WAITING" (esperando), "RETURNING" (voltando), "DONE" (acabou)
var state: String = "IDLE" 

func _ready():
	# Guarda a posição inicial
	start_position = position
	
	# Detector detecta o player
	$Detector.connect("body_entered", _on_detector_body_entered)
	
	# Trap causa dano quando colide
	connect("body_entered", _on_body_entered)
	
func _on_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(damage)
		
func _physics_process(delta):
	# Lógica de movimento baseada no estado atual
	if state == "GOING":
		position = position.move_toward(target_position, speed * delta)
		
		# Se chegou no alvo
		if position.distance_to(target_position) < 0.1:
			start_wait_timer()
			
	elif state == "RETURNING":
		position = position.move_toward(start_position, speed * delta)
		
		# Se chegou de volta ao início
		if position.distance_to(start_position) < 0.1:
			state = "DONE" # Define como DONE para nunca mais ativar

func _on_detector_body_entered(body):
	# Só ativa se estiver no estado inicial (IDLE) e for o Player
	if state == "IDLE" and body.is_in_group("Player"):
		activate_trap(body)

func activate_trap(player):
	# 1. Descobre a direção horizontal do player (-1 esquerda, 1 direita)
	var direction_x = sign(player.global_position.x - global_position.x)
	
	# Se a direção for 0 (estão exatamente no mesmo pixel X), chuta para a direita
	if direction_x == 0: direction_x = 1
	
	# 2. Define o alvo (Posição atual + distância na direção X)
	# Mantém o Y original (0 no segundo parametro do Vector2)
	target_position = start_position + Vector2(direction_x * move_distance, 0)
	
	# 3. Muda o estado para começar a andar
	state = "GOING"
	
	# DICA: Se o seu node for um AnimatedSprite2D, descomente abaixo:
	$Sprite2D.play("default") 

func start_wait_timer():
	state = "WAITING"
	# Cria um timer temporário de 5 segundos
	await get_tree().create_timer(wait_time).timeout
	# Após o tempo acabar, muda o estado para voltar
	state = "RETURNING"
