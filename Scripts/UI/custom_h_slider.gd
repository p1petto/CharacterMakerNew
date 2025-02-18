extends HSlider

#signal slider_value_changed

@export var linked_marker: int
@export var character_part: String
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_value_changed(value: float) -> void:
	#slider_value_changed.emit(value, linked_marker, character_part)
	pass
