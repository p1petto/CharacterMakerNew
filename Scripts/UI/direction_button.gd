extends TextureButton

@export_enum("down", "right", "top", "left") 
var direction: String = "down"


signal direction_changed


func _on_button_up() -> void:
	Global.current_dir = direction
	direction_changed.emit()
