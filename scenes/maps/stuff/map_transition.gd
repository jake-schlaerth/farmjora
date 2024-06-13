extends Area2D

@export var new_map_name: String
@export var enter_position: Vector2

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group('player'):
		signal_bus.change_map.emit(new_map_name, enter_position, [])
