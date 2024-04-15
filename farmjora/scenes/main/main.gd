extends Node

func _ready() -> void:
	$Music.play()

func new_game() -> void:
	$Player.start($StartPosition.position)
