extends Node

func _ready():
	# Define a resolução base do jogo
	DisplayServer.window_set_size(Vector2i(1280, 720))

	# Força modo tela cheia
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

	# Garante que a janela não pode ser redimensionada (opcional)
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_RESIZE_DISABLED, true)
