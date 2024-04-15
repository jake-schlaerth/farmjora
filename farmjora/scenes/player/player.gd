extends CharacterBody2D
signal hit

@export var speed := 25
@export var inventory: Inventory
@export var equipped_inventory_item: InventoryItem

var last_direction := Vector2(0, 1)
var control_enabled := false

func _ready() -> void:
	SignalBus.equip_inventory_item.connect(on_equip_inventory_item)
	hide()

func _physics_process(_delta: float) -> void:
	if not control_enabled:
		return
		
	velocity = Vector2.ZERO
	var current_direction := Vector2.ZERO

	if Input.is_action_pressed("move_right"):
		velocity.x += 1
		current_direction = Vector2(1, 0)
		$AnimatedSprite2D.flip_h = true
	elif Input.is_action_pressed("move_left"):
		velocity.x -= 1
		current_direction = Vector2(-1, 0)
		$AnimatedSprite2D.flip_h = false

	if Input.is_action_pressed("move_down"):
		velocity.y += 1
		current_direction = Vector2(0, 1)
	elif Input.is_action_pressed("move_up"):
		velocity.y -= 1
		current_direction = Vector2(0, -1)

	if current_direction != Vector2.ZERO:
		last_direction = current_direction
		$AnimatedSprite2D.animation = get_moving_animation_name(last_direction)
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
		$AnimatedSprite2D.animation = get_still_animation_name(last_direction)

	velocity = velocity.normalized() * speed
	move_and_slide()
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and equipped_inventory_item:
		use_equipped_inventory_item()

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
	show()
	$CollisionShape2D.disabled = false
	
func collect(inventory_item: InventoryItem) -> void:
	inventory.insert_inventory_item(inventory_item)

func on_equip_inventory_item(inventory_item: InventoryItem) -> void:
	equipped_inventory_item = inventory_item;
	
func use_equipped_inventory_item() -> void:
	SignalBus.use_equipped_inventory_item.emit(equipped_inventory_item)
