extends Resource

class_name InventorySlot

@export var inventory_item: InventoryItem
@export var item_quantity: int


func initialize() -> void:
	signal_bus.decrement_item_quantity.connect(on_decrement_item_quantity)

func increment_quantity() -> void:
	item_quantity += 1

func on_decrement_item_quantity(item_name: String ) -> void:
	if inventory_item and inventory_item.name == item_name:
		decrement_item_quantity()

func decrement_item_quantity() -> void:
	if item_quantity == 1:
		inventory_item = null
		signal_bus.unequip_inventory_item.emit()
	else:
		item_quantity -= 1
	signal_bus.update_inventory_ui.emit()
