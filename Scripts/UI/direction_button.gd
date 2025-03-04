extends Button

@export_enum("down", "right", "top", "left") 
var direction: String = "down"

signal direction_changed
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_up() -> void:
	Global.current_dir = direction
	direction_changed.emit()
