extends CanvasLayer

func _on_start_button_pressed() -> void:
	var deferred_callbacks := [
		start_game
	]
	
	signal_bus.change_map.emit('SmallWorld', Vector2(0,0), deferred_callbacks)

func start_game() -> void:
	$EquippedInventoryItemUI.show()
	$StartButton.hide()
	$Message.hide()
	signal_bus.start_game.emit()

