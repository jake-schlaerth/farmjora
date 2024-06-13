class_name MapManager extends Node

@export var initial_map_name := "InitialMap"

var maps := {
	"InitialMap": {
		"path": "res://scenes/maps/initial_map.tscn",
		"instance": null,
	},
	"SmallWorld": {
		"path": "res://scenes/maps/small_world.tscn",
		"instance": null, 
	}, 
	"Dirt1": {
		"path": "res://scenes/maps/dirt_1.tscn",
		"instance": null, 
	},
	"Home": {
		"path": "res://scenes/maps/home.tscn",
		"instance": null,
	}
}
var map_container: Node2D
var current_map_name : String
var exit_position := Vector2(999999, 999999)
var enter_position := Vector2(0, 0)

func _ready() -> void:
	signal_bus.change_map.connect(on_change_map)

func initialize(main_map_container: Node2D) -> void:
	print(initial_map_name)
	map_container = main_map_container
	load_and_persist(initial_map_name)
	enter_map(initial_map_name)
	current_map_name = initial_map_name


func on_change_map(new_map_name: String, player_position: Vector2, deferred_callbacks: Array = []) -> void:
	var merged_deferred_callbacks := [
		func() -> void: change_map(new_map_name, player_position)
	] + deferred_callbacks
	
	signal_bus.transition.emit(merged_deferred_callbacks)

func change_map(new_map_name: String, player_position: Vector2) -> void:
	if player_manager.get_player():
		player_manager.get_player().position = player_position
	if is_new_map(new_map_name):
		load_and_persist(new_map_name)
	exit_map(current_map_name)
	enter_map(new_map_name)
	current_map_name = new_map_name

func load_and_persist(map_name: String) -> void:
	var map_resource := load(maps[map_name].path)
	var map_instance: TileMap = map_resource.instantiate()
	maps[map_name].instance = map_instance
	map_container.add_child(map_instance)

func exit_map(map_name: String) -> void:
	if is_new_map(map_name):
		return
	get_map_instance(map_name).position = exit_position

func enter_map(map_name: String) -> void:
	get_map_instance(map_name).position = enter_position

func is_new_map(map_name: String) -> bool:
	return get_map_instance(map_name) == null

func get_map_instance(map_name: String) -> TileMap:
	return maps[map_name].instance
