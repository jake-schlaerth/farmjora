extends Resource

class_name Plant

@export var name: String = ""
@export var day_planted: int
@export var days_to_grow: int

func is_harvestable() -> bool:
	return get_days_since_planted() >= days_to_grow

func get_days_since_planted() -> int:
	return DayCounter.current_day - day_planted
