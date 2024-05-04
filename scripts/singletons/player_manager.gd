extends Node

var player_resource := load("res://scenes/player/player.tscn")
var player: CharacterBody2D
var start_position := Vector2(0, 0)

func _ready() -> void:
	signal_bus.start_game.connect(on_start_game)

func on_start_game() -> void:
	player = player_resource.instantiate()
	get_tree().root.add_child.call_deferred(player)
	player.start(start_position)

func get_player() -> CharacterBody2D:
	return player
