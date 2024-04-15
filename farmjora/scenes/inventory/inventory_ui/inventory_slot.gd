extends Resource

class_name InventorySlot

@export var inventory_item: InventoryItem
@export var item_quantity: int

func increment_quantity() -> void:
	item_quantity += 1
