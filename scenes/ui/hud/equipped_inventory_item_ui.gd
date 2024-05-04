extends Panel

@onready var item_image := $ItemImage
@onready var item_quantity_label := $Label
@export var equipped_inventory_item: InventoryItem
@export var equipped_item_quantity: int


func _ready() -> void:
	signal_bus.decrement_item_quantity.connect(on_decrement_item_quantity)
	signal_bus.equip_inventory_item.connect(on_equip_inventory_item)

func on_decrement_item_quantity(_item_name: String) -> void:
	equipped_item_quantity -= 1
	if equipped_item_quantity == 0:
		equipped_inventory_item = null
	update()
	
func on_equip_inventory_item(inventory_item: InventoryItem, item_quantity: int) -> void:
	equipped_item_quantity = item_quantity
	equipped_inventory_item = inventory_item
	update()

func update() -> void:
	if (!equipped_inventory_item):
		item_image.texture = null
		return
	item_image.texture = equipped_inventory_item.texture
	item_quantity_label.text = str(equipped_item_quantity)
