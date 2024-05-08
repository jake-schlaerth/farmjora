extends Node

var current_day := 1
var total_days_passed := 0

func _ready() -> void:
	signal_bus.increment_day.connect(on_increment_day)
	
func on_increment_day() -> void:
	current_day += 1
	total_days_passed += 1

func get_current_day() -> int:
	return current_day
