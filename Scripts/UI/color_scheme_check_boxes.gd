extends HBoxContainer

var check_button_pressed: Array[int] = []
@onready var accept_button = $"../../MarginContainer/Accept"

func _ready() -> void:
	for child in get_children():
		if child is CheckButton:
			child.connect("button_toggled", Callable(self, "_on_button_toggled"))
	update_accept_button()

func _on_button_toggled(button: CheckButton, toggled_on: bool) -> void:
	var index: int = button.get_index()

	if toggled_on:
		if index not in check_button_pressed:
			check_button_pressed.append(index)
	else:
		check_button_pressed.erase(index)

	update_accept_button()

func update_accept_button() -> void:
	accept_button.disabled = check_button_pressed.is_empty()
