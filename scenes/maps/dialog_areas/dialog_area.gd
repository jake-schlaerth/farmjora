extends Area2D

@export var dialog_key := ""
var area_active := false

func _input(event: InputEvent) -> void:
	if area_active and event.is_action_pressed("ui_accept"):
		signal_bus.emit_signal("display_dialog", dialog_key)

func _on_area_entered(_area: Area2D) -> void:
	area_active = true

func _on_area_exited(_area: Area2D) -> void:
	area_active = false
