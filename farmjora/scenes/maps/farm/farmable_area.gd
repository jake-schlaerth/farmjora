extends Node2D

@onready var image := $Image
@onready var collision_area := $Area2D

@export var state := TILE_STATE.UNTILLED

enum TILE_STATE {TILLED, UNTILLED}

var is_active := false

func _ready() -> void:
	SignalBus.use_equipped_inventory_item.connect(on_use_equipped_inventory_item)
	update_visibility()
	
func on_use_equipped_inventory_item(inventory_item: InventoryItem):
	if inventory_item.name == 'hoe':
		use_hoe(inventory_item)
		
func use_hoe(hoe_inventory_item: InventoryItem):
	if is_active:
		state = TILE_STATE.TILLED
		update_visibility()

func update_visibility():
	image.visible = state == TILE_STATE.TILLED

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group('player'):
		is_active = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group('player'):
		is_active = false
