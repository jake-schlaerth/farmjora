extends Control

@onready var texture_rect := $TextureRect
@onready var animation_player := $AnimationPlayer

var _deferred_callbacks: Array

func _ready() -> void:
	signal_bus.transition.connect(on_transition)
	texture_rect.visible = false

func on_transition(deferred_callbacks: Array = []) -> void:
	if player_manager.get_player():
		player_manager.get_player().control_enabled = false
		
	animation_player.queue("fade_out")
	set_deferred_callbacks(deferred_callbacks)

func _on_animation_player_animation_started(animation_name: StringName) -> void:
	if animation_name == "fade_out":
		get_tree().paused = true

func _on_animation_player_animation_finished(animation_name: StringName) -> void:
	if animation_name == "fade_out":
		call_deferred_callbacks()
		animation_player.queue("fade_in")
	if animation_name == "fade_in":
		get_tree().paused = false
		player_manager.get_player().control_enabled = true

func set_deferred_callbacks(deferred_callbacks: Array) -> void:
	_deferred_callbacks = deferred_callbacks

func call_deferred_callbacks() -> void:
	for deferred_callback: Callable in _deferred_callbacks:
		deferred_callback.call_deferred()
