extends Area2D
signal hit

@export var speed = 100
var last_direction = Vector2(0, 1)
var screen_size

func _ready():
	screen_size = get_viewport_rect().size
	hide()

func _process(delta):
	var velocity = Vector2.ZERO
	var current_direction = Vector2.ZERO

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

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)

func get_moving_animation_name(direction: Vector2) -> String:
	if direction == Vector2(0, -1): # Up
		return "walk up"
	elif direction == Vector2(0, 1): # Down
		return "walk down"
	elif direction.x == 1: # Right
		return "walk left"
	elif direction.x == -1: # Left
		return "walk left"
	return "default" # Fallback
	
func get_still_animation_name(direction: Vector2) -> String:
	if direction == Vector2(0, -1): # Up
		return "still up"
	elif direction == Vector2(0, 1): # Down
		return "still down"
	elif direction.x == 1: # Right
		return "still left"
	elif direction.x == -1: # Left
		return "still left"
	return "default" # Fallback

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
	
func _on_body_entered(_body):
	hide()
	hit.emit()
	# Must be deferred as we can't change physics properties on a physics callback.
	$CollisionShape2D.set_deferred("disabled", true)
