extends Panel

@onready var item_image = $ItemImage
@export var equipped_inventory_item: InventoryItem

func _ready() -> void:
	SignalBus.equip_inventory_item.connect(on_equip_inventory_item)
	
func on_equip_inventory_item(inventory_item: InventoryItem):
	item_image.texture = inventory_item.texture
