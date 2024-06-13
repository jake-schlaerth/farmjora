extends AnimatedSprite2D

@onready var player := player_manager.get_player()

var equipped_inventory_item: InventoryItem
var has_equipped_inventory_item := false

func _ready() -> void:
	signal_bus.equip_inventory_item.connect(on_equip_inventory_item)

func _physics_process(_delta: float) -> void:
	if !has_equipped_inventory_item:
		visible = false
		return
	if player.current_direction != Vector2.ZERO:
		animation = get_moving_animation_name(player.last_direction)
		play()
	else:
		stop()
		animation = get_still_animation_name(player.last_direction)
	
func get_moving_animation_name(direction: Vector2) -> String:
	if direction == Vector2(0, -1): # Up
		flip_h = false
		z_index = 0
		return equipped_inventory_item.name + "_down"
	elif direction == Vector2(0, 1): # Down
		flip_h = false
		z_index = 2
		return equipped_inventory_item.name + "_down"
	elif direction.x == 1: # Right
		flip_h = true
		z_index = 2
		return equipped_inventory_item.name + "_left"
	elif direction.x == -1: # Left
		flip_h = false
		z_index = 0
		return equipped_inventory_item.name + "_left"
	return "error"

func get_still_animation_name(direction: Vector2) -> String:
	if direction == Vector2(0, -1): # Up
		flip_h = false
		return equipped_inventory_item.name + "_down_still"
	elif direction == Vector2(0, 1): # Down
		flip_h = false
		return equipped_inventory_item.name + "_down_still"
	elif direction.x == 1: # Right
		flip_h = true
		return equipped_inventory_item.name + "_left_still"
	elif direction.x == -1: # Left
		flip_h = false
		return equipped_inventory_item.name + "_left_still"
	return "default"

func on_equip_inventory_item(inventory_item: InventoryItem, _item_quantity: int) -> void:
	equipped_inventory_item = inventory_item
	has_equipped_inventory_item = true
	visible = true
