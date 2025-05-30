extends TextureButton

@export var value: Vector2

signal change_position


func _on_button_up() -> void:
	change_position.emit(value)
