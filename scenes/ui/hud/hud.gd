extends CanvasLayer

func _on_start_button_pressed() -> void:
	$StartButton.hide()
	$Message.hide()
	signal_bus.start_game.emit()
