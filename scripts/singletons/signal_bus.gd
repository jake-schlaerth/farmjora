extends Node

signal start_game()
signal display_dialog(text_key: String)
signal update_inventory_ui()
signal equip_inventory_item(inventory_item: InventoryItem, item_quantity: int)
signal unequip_inventory_item()
signal use_equipped_inventory_item(inventory_item: InventoryItem)
signal transition(deferred_signals: Array[Callable])
signal change_map(map_name: String, enter_position: Vector2)
signal increment_day()
signal decrement_item_quantity(inventory_item_name: String)
signal inventory_ready(inventory: Inventory)
