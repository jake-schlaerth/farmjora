extends CharacterBody2D

var movement_speed: float = 20.0
var movement_target_position := Vector2(get_randf(), get_randf())
var should_move := true

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D

func _ready() -> void:
	$AnimatedSprite2D.animation = "move"
	$AnimatedSprite2D.play()

	navigation_agent.path_desired_distance = 4.0
	navigation_agent.target_desired_distance = 4.0
	set_physics_process(false)
	call_deferred("actor_setup")
	

func get_randf() -> float:
	return randf_range(-200, 200)

func actor_setup() -> void:
	set_movement_target(get_movement_target())
	set_physics_process(true)

func get_movement_target() -> Vector2:
	return Vector2(get_randf(), get_randf())

func set_movement_target(movement_target: Vector2) -> void:
	navigation_agent.target_position = movement_target

func wait() -> void:
	$AnimatedSprite2D.animation = "still"
	$AnimatedSprite2D.play()
	should_move = false
	await get_tree().create_timer(randf_range(5, 15)).timeout
	should_move = true
	$AnimatedSprite2D.animation = "move"
	$AnimatedSprite2D.play()

func _physics_process(_delta: float) -> void:
	if not should_move:
		return

	if navigation_agent.is_navigation_finished():
		wait()
		set_movement_target(get_movement_target())

	var current_agent_position: Vector2 = global_position
	var next_path_position: Vector2 = navigation_agent.get_next_path_position()

	velocity = current_agent_position.direction_to(next_path_position) * movement_speed
	move_and_slide()
