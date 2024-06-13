extends Node

@onready var camera := $Camera2D

func _ready() -> void:
	$Music.play()
	map_manager.initialize($MapContainer)
	signal_bus.start_game.connect(on_start_game)

func on_start_game() -> void:
	camera.enabled = false
