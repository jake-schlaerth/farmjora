extends Area2D

var area_active := false

func _input(event: InputEvent) -> void:
	if area_active and event.is_action_pressed("ui_accept"):
		var deferred_callbacks := [
			func() -> void: signal_bus.increment_day.emit()
		]
		signal_bus.transition.emit(deferred_callbacks)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group('player'):
		area_active = true

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group('player'):
		area_active = false
