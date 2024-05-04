extends Plant

class_name Carrot

var textures: Array = []

func _init() -> void:
	name = "carrot"
	load_textures()
	days_to_grow = 4

func load_textures() -> void:
	textures.append(preload("res://assets/sprites/plants/carrot/carrot_1.png"))
	textures.append(preload("res://assets/sprites/plants/carrot/carrot_2.png"))
	textures.append(preload("res://assets/sprites/plants/carrot/carrot_3.png"))
	textures.append(preload("res://assets/sprites/plants/carrot/carrot_4.png"))

func get_texture() -> Texture:
	var days_since_planted := get_days_since_planted()
	return textures[min(days_since_planted, textures.size() - 1)]
