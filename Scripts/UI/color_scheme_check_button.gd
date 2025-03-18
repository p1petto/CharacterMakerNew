extends CheckButton

@export_enum("Body", "Clothes", "Accessory")
var clothes_type: String 

signal button_toggled(button: CheckButton, toggled_on: bool)


func _on_toggled(toggled_on: bool) -> void:
	button_toggled.emit(self, toggled_on)
