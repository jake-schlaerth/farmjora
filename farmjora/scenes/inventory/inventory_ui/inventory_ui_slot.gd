extends Panel

@onready var item_image: Sprite2D = $CenterContainer/Panel/ItemImage
@onready var item_quantity_label := $CenterContainer/Panel/Label
@export var inventory_item: InventoryItem

var is_active := false

func update(inventory_slot: InventorySlot) -> void:
	if (inventory_slot.inventory_item):
		inventory_item = inventory_slot.inventory_item
		item_image.visible = true
		item_image.texture = inventory_slot.inventory_item.texture
		item_quantity_label.visible = inventory_slot.item_quantity > 1
		item_quantity_label.text = str(inventory_slot.item_quantity)
	else:
		item_image.visible = false
		item_quantity_label.visible = false

func _on_mouse_entered() -> void:
	is_active = true

func _on_mouse_exited() -> void:
	is_active = false

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and is_active:
		equip_item()

func equip_item() -> void:
	if inventory_item and inventory_item.equipable:
		SignalBus.emit_signal("equip_inventory_item", inventory_item)
