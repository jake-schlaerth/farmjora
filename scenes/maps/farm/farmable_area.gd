extends Node2D

@onready var images := $Images
@onready var plant_image := $Images/PlantImage
@onready var collision_area := $Area2D

@export var state := TILE_STATE.UNTILLED
@export var plant: Plant

var area_active := false

enum TILE_STATE {UNTILLED, TILLED, PLANTED}

var plants := {
	"carrot": {
		"plant_resource": load("res://scenes/plants/carrot.tres"),
		"inventory_resource": load("res://scenes/inventory/inventory_items/carrot.tres")
	}
}

func _ready() -> void:
	signal_bus.use_equipped_inventory_item.connect(on_use_equipped_inventory_item)
	signal_bus.increment_day.connect(on_increment_day)
	update_visibility()

func _input(event: InputEvent) -> void:
	if area_active and event.is_action_pressed("ui_accept"):
		harvest_plant()

func on_use_equipped_inventory_item(inventory_item: InventoryItem) -> void:
	if inventory_item.name == 'hoe':
		use_hoe(inventory_item)
	if inventory_item.type == GlobalConstants.INVENTORY_ITEM_TYPE.SEED:
		use_seed(inventory_item)

func on_increment_day() -> void:
	if state == TILE_STATE.PLANTED:
		plant_image.texture = plant.get_texture()
		update_visibility()

func use_hoe(_hoe_inventory_item: InventoryItem) -> void:
	if area_active:
		state = TILE_STATE.TILLED
		update_visibility()

func use_seed(inventory_seed: InventoryItem) -> void:
	if area_active and tile_is_tilled():
		plant_seed(inventory_seed)

func plant_seed(inventory_seed: InventoryItem) -> void:
	if state == TILE_STATE.PLANTED:
		return

	plant = get_plant_resource(inventory_seed).duplicate()
	plant.day_planted = DayCounter.current_day
	plant_image.texture = plant.get_texture()
	state = TILE_STATE.PLANTED
	update_visibility()
	
	signal_bus.decrement_item_quantity.emit(inventory_seed.name)

func get_plant_resource(inventory_seed: InventoryItem) -> Plant:
	return plants[inventory_seed.plant.name].plant_resource

func get_plant_inventory_item() -> InventoryItem:
	return plants[plant.name].inventory_resource

func tile_is_tilled() -> bool:
	return state == TILE_STATE.TILLED
	
func update_visibility() -> void:
	images.visible = state != TILE_STATE.UNTILLED
	plant_image.visible = state == TILE_STATE.PLANTED

func harvest_plant() -> void:
	if state == TILE_STATE.PLANTED && plant.is_harvestable():
		player_manager.get_player().collect(get_plant_inventory_item())
		reset()

func reset() -> void:
	state = TILE_STATE.TILLED
	update_visibility()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group('player'):
		area_active = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group('player'):
		area_active = false
