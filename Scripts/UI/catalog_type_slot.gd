extends TextureButton

@export var tab_name: String
@onready var label = $Label

signal catalog_tab_changed

func set_label(str: String):
	label.text = str
	
func _process(delta: float) -> void:
	pass


func _on_button_up() -> void:
	catalog_tab_changed.emit(tab_name)
