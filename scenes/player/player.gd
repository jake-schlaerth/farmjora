extends CharacterBody2D
signal hit

@export var speed := 25
@export var inventory: Inventory
@export var equipped_inventory_item: InventoryItem

var has_equipped_inventory_item := false
var last_direction := Vector2(0, 1)
var current_direction:= Vector2.ZERO
var control_enabled := false
var mouse_button_held := false
var inventory_slot_quantity := 12
var debug := true

func _ready() -> void:
	signal_bus.equip_inventory_item.connect(on_equip_inventory_item)
	signal_bus.unequip_inventory_item.connect(on_unequip_inventory_item)
	initialize_inventory()

func _process(_delta: float) -> void:
	if mouse_button_held and equipped_inventory_item:
		use_equipped_inventory_item()

func _physics_process(_delta: float) -> void:
	if not control_enabled:
		$PlayerSprite.stop()
		$PlayerSprite.animation = get_still_animation_name(last_direction)
		return
		
	velocity = Vector2.ZERO
	current_direction = Vector2.ZERO

	if Input.is_action_pressed("move_right"):
		velocity.x += 1
		current_direction = Vector2(1, 0)
		$PlayerSprite.flip_h = true
	elif Input.is_action_pressed("move_left"):
		velocity.x -= 1
		current_direction = Vector2(-1, 0)
		$PlayerSprite.flip_h = false

	if Input.is_action_pressed("move_down"):
		velocity.y += 1
		current_direction = Vector2(0, 1)
	elif Input.is_action_pressed("move_up"):
		velocity.y -= 1
		current_direction = Vector2(0, -1)

	if current_direction != Vector2.ZERO:
		last_direction = current_direction
		$PlayerSprite.animation = get_moving_animation_name(last_direction)
		$PlayerSprite.play()
	else:
		$PlayerSprite.stop()
		$PlayerSprite.animation = get_still_animation_name(last_direction)

	velocity = velocity.normalized() * speed
	move_and_slide()

func _input(event: InputEvent) -> void:
	if not control_enabled:
		return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		mouse_button_held = event.pressed

func initialize_inventory() -> void:
	inventory = Inventory.new()
	initialize_inventory_slots()

func initialize_inventory_slots() -> void:
	for slot_idx in inventory_slot_quantity:
		var inventory_slot := InventorySlot.new()
		inventory_slot.initialize()
		inventory.inventory_slots.append(inventory_slot)
	if (debug): 
		add_debug_items(inventory.inventory_slots)
	signal_bus.inventory_ready.emit(inventory)
	
func add_debug_items(inventory_slots: Array[InventorySlot]) -> void:
	var carrot_seed_resource := load("res://scenes/inventory/inventory_items/seeds/carrot_seeds.tres")
	inventory_slots[0].inventory_item = carrot_seed_resource.duplicate()
	inventory_slots[0].item_quantity = 20

	var hoe_resource := load("res://scenes/inventory/inventory_items/hoe.tres")
	inventory_slots[1].inventory_item = hoe_resource.duplicate()
	inventory_slots[1].item_quantity = 1

func get_moving_animation_name(direction: Vector2) -> String:
	if direction == Vector2(0, -1): # Up
		return "walk down"
	elif direction == Vector2(0, 1): # Down
		return "walk down"
	elif direction.x == 1: # Right
		return "walk left"
	elif direction.x == -1: # Left
		return "walk left"
	return "default" # Fallback
	
func get_still_animation_name(direction: Vector2) -> String:
	if direction == Vector2(0, -1): # Up
		return "still down"
	elif direction == Vector2(0, 1): # Down
		return "still down"
	elif direction.x == 1: # Right
		return "still left"
	elif direction.x == -1: # Left
		return "still left"
	return "default" # Fallback

func start(desired_position: Vector2) -> void:
	position = desired_position
	control_enabled = true

func collect(inventory_item: InventoryItem) -> void:
	inventory.insert_inventory_item(inventory_item)

func on_equip_inventory_item(inventory_item: InventoryItem, _item_quantity: int) -> void:
	has_equipped_inventory_item = true
	equipped_inventory_item = inventory_item;
	
func use_equipped_inventory_item() -> void:
	if (has_equipped_inventory_item):
		signal_bus.use_equipped_inventory_item.emit(equipped_inventory_item)

func on_unequip_inventory_item() -> void:
	has_equipped_inventory_item = false
