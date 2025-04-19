extends Container

@onready var scroll_container = $ButtonsScrollContainer
@onready var color_picker_buttons = $ColorPickerButtons
@onready var animation_player = $AnimationPlayer

signal container_catallog_type_position_changed

func _ready() -> void:
	get_viewport().connect("size_changed", Callable(self, "_on_viewport_resized"))
	await get_tree().process_frame
	_update_positions()

func _on_viewport_resized() -> void:
	await get_tree().process_frame
	_update_positions()

func _update_positions() -> void:
	scroll_container.position.x = get_viewport_rect().size.x / 2 - scroll_container.size.x / 2

	color_picker_buttons.position.x = scroll_container.position.x + scroll_container.size.x + 28
	color_picker_buttons.position.y = scroll_container.position.y + (scroll_container.size.y - color_picker_buttons.size.y) / 2
	
	#animation_player.position.x = scroll_container.position.x / 2 - animation_player.size.x / 2
	animation_player.position.x = 16
	animation_player.position.y = scroll_container.position.y + (scroll_container.size.y - color_picker_buttons.size.y) / 2 - 16
	container_catallog_type_position_changed.emit()
