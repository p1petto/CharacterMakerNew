extends HSlider

signal slider_value_changed

@export var linked_marker: int
@export var character_part: String
@export var axis: String

signal drag_started_slider

var animation_was_running = false


func _on_value_changed(value: float) -> void:
	slider_value_changed.emit(value, linked_marker, character_part, axis)
	pass


func _on_drag_started() -> void:
	if Global.animation_is_run:
		Global.animation_is_run = false
		animation_was_running = true


func _on_drag_ended(value_changed: bool) -> void:
	if animation_was_running:
		Global.animation_is_run = true
		animation_was_running = false
