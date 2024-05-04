extends Node

func _ready() -> void:
	$Music.play()
	map_manager.initialize($MapContainer)
