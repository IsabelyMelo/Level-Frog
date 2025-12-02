extends CharacterBody2D

# ===============================
#  MOVIMENTO
# ===============================
var speed: float = 200.0
var motion: Vector2 = Vector2.ZERO

var gravity: float = 600.0
var max_fall_speed: float = 1000.0
var jump_force: float = 400.0

# POSIÇÃO INICIAL (RESPAWN)
var origin_position: Vector2

# ===============================
#  ANIMAÇÃO / SPRITE
# ===============================
@onready var anim: AnimatedSprite2D = $Sprite2D
var base_scale_x: float = 0.6
var base_scale_y: float = 0.6
@onready var jump_fx: AudioStreamPlayer = $jump

# FLIP SUAVE
var is_flipping: bool = false
var flip_duration: float = 0.18
var flip_timer: float = 0.0
var flip_toggled: bool = false
var desired_flip_h: bool = false
var start_scale_x: float = 0.0

# ===============================
#  VIDA
# ===============================
var current_health: int = 0
var max_health: int = 100
@onready var health_bar_fill: ColorRect = $"../vida/ColorRect_Fill"


# ===============================
#  READY
# ===============================
func _ready() -> void:
	anim.scale = Vector2(base_scale_x, base_scale_y)
	current_health = max_health
	origin_position = global_position  # Ponto de nascimento


# ===============================
#  INPUT
# ===============================
func get_input() -> void:
	motion.x = 0
	
	if Input.is_action_pressed("ui_left"):
		motion.x -= 1
		if not is_flipping and anim.flip_h == false:
			start_flip_to(true)

	elif Input.is_action_pressed("ui_right"):
		motion.x += 1
		if not is_flipping and anim.flip_h == true:
			start_flip_to(false)

	if Input.is_action_just_pressed("Damage"):
		take_damage(10)
	elif Input.is_action_just_released("Heal"):
		heal(10)

	motion = motion.normalized() * speed


# ===============================
#  FLIP SUAVE
# ===============================
func start_flip_to(flip_h_value: bool) -> void:
	if is_flipping:
		return
	is_flipping = true
	flip_timer = 0.0
	flip_toggled = false
	desired_flip_h = flip_h_value
	start_scale_x = anim.scale.x if anim.scale.x != 0 else base_scale_x

func process_flip(delta: float) -> void:
	if not is_flipping:
		return

	flip_timer += delta
	var t: float = clamp(flip_timer / flip_duration, 0.0, 1.0)

	if t < 0.5:
		var step: float = t * 2.0
		anim.scale.x = lerp(start_scale_x, 0.0, step)
	else:
		var step: float = (t - 0.5) * 2.0
		if not flip_toggled:
			anim.flip_h = desired_flip_h
			flip_toggled = true
		anim.scale.x = lerp(0.0, base_scale_x, step)

	if t >= 1.0:
		is_flipping = false
		flip_timer = 0.0
		anim.scale.x = base_scale_x
		flip_toggled = false


# ===============================
#  ANIMAÇÃO
# ===============================
func update_animation() -> void:
	if not is_on_floor():
		if velocity.y < 0:
			anim.play("jump")
		else:
			anim.play("land")
	elif motion.x != 0:
		anim.play("walk")
	else:
		anim.play("idle")


# ===============================
#  FÍSICA / MOVIMENTO
# ===============================
func _physics_process(delta: float) -> void:
	get_input()

	velocity.y += gravity * delta
	if velocity.y > max_fall_speed:
		velocity.y = max_fall_speed
	
	velocity.x = motion.x

	if is_on_floor() and Input.is_action_pressed("ui_jump"):
		velocity.y = -jump_force
		jump_fx.play()

	move_and_slide()
	process_flip(delta)
	update_animation()


# ===============================
#  VIDA / DANO / MORTE
# ===============================
func take_damage(amount: int) -> void:
	current_health -= amount
	current_health = clamp(current_health, 0, max_health)
	update_health_bar()

func heal(amount: int) -> void:
	current_health += amount
	current_health = clamp(current_health, 0, max_health)
	update_health_bar()

func update_health_bar() -> void:
	var ratio: float = float(current_health) / max_health
	health_bar_fill.scale.x = ratio

	if current_health <= 0:
		die()


# ===============================
#  💀 MORREU → REINICIA A CENA
# ===============================
func die() -> void:
	print("Morreu — Reiniciando a cena...")
	var tree := get_tree()
	if tree:
		tree.call_deferred("reload_current_scene")
