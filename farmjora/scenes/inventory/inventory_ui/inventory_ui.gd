extends Control

@onready var inventory: Inventory = preload("res://scenes/inventory/inventories/player_inventory.tres")
@onready var inventory_ui_slots: Array[Node] = $GridContainer.get_children()

var is_open := false

func _ready() -> void:
	inventory.update_inventory_ui.connect(update_slots)
	update_slots()
	close()
	
func _process(_delta: float) -> void:
	if (Input.is_action_just_pressed("inventory")):
		if (is_open):
			close()
		else:
			open()
			
func update_slots() -> void:
	for idx in inventory_ui_slots.size():
		var inventory_ui_slot := inventory_ui_slots[idx]
		inventory_ui_slot.update(inventory.inventory_slots[idx])

func close() -> void:
	is_open = false
	visible = false
	
func open() -> void:
	visible = true
	is_open = true
