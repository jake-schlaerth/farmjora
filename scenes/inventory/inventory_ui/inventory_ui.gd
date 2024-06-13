extends Control

@onready var inventory_ui_slots: Array[Node] = $GridContainer.get_children()
var inventory: Inventory
var is_open := false

func _ready() -> void:
	signal_bus.inventory_ready.connect(on_inventory_ready)
	signal_bus.update_inventory_ui.connect(update_slots)
	close()

func _process(_delta: float) -> void:
	if (Input.is_action_just_pressed("inventory")):
		if (is_open):
			close()
		else:
			open()

func on_inventory_ready(player_inventory: Inventory) -> void:
	inventory = player_inventory
	update_slots()

func update_slots() -> void:
	for idx in inventory_ui_slots.size():
		var inventory_ui_slot := inventory_ui_slots[idx]
		inventory_ui_slot.update(inventory.inventory_slots[idx])

func close() -> void:
	player_manager.get_player().control_enabled = true
	get_tree().paused = false
	is_open = false
	visible = false
	get_tree().paused = false
	
func open() -> void:
	player_manager.get_player().control_enabled = false
	get_tree().paused = true
	visible = true
	is_open = true
	get_tree().paused = true
