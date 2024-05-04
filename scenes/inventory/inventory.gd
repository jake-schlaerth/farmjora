extends Resource

class_name Inventory
@export var inventory_slots: Array[InventorySlot]

func insert_inventory_item(inventory_item: InventoryItem) -> void:
	if has_inventory_item(inventory_item):
		var slot_with_item: InventorySlot = get_slots_with_item(inventory_item).front()
		slot_with_item.increment_quantity()
		signal_bus.update_inventory_ui.emit()
	else:
		insert_into_empty_slot(inventory_item)

func insert_into_empty_slot(inventory_item: InventoryItem) -> void:
	if is_inventory_full():
		#can't pick up
		pass
	else:
		var empty_inventory_slot: InventorySlot = get_empty_inventory_slots().front()
		empty_inventory_slot.inventory_item = inventory_item
		empty_inventory_slot.item_quantity = 1	
		signal_bus.update_inventory_ui.emit()


func is_inventory_full() -> bool:
	return get_empty_inventory_slots().is_empty()
	
func get_empty_inventory_slots() -> Array[InventorySlot]:
	return inventory_slots.filter(
		func (inventory_slot: InventorySlot) -> bool:
			return inventory_slot.inventory_item == null
	)

func has_inventory_item(item: InventoryItem) -> bool:
	return get_slots_with_item(item).size() >= 1

func get_slots_with_item(inventory_item: InventoryItem) -> Array[InventorySlot]:
	return inventory_slots.filter(
		func (inventory_slot: InventorySlot) -> bool:
			return inventory_slot.inventory_item == inventory_item
	)
