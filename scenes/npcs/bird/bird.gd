extends CharacterBody2D

@export var movement_speed: float = 50.0
@export var start_position := Vector2(300, 20)

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D

var should_move := false

func _ready() -> void:
	$AnimatedSprite2D.play()

	navigation_agent.path_desired_distance = 4.0
	navigation_agent.target_desired_distance = 4.0
	set_physics_process(false)
	call_deferred("actor_setup")

func actor_setup() -> void:
	set_position(start_position)
	set_movement_target(start_position * -1)
	wait()
	set_physics_process(true)

func wait() -> void:
	$AnimatedSprite2D.pause()
	should_move = false
	await get_tree().create_timer(randf_range(5, 15)).timeout
	should_move = true
	$AnimatedSprite2D.play()

func set_movement_target(movement_target: Vector2) -> void:
	navigation_agent.target_position = movement_target

func _physics_process(_delta: float) -> void:
	if not should_move:
		return

	if navigation_agent.is_navigation_finished():
		wait()
		set_position(start_position)
		set_movement_target(start_position * 1)
	var current_agent_position := global_position
	var next_path_position := navigation_agent.get_next_path_position()

	velocity = current_agent_position.direction_to(next_path_position) * movement_speed
	move_and_slide()
