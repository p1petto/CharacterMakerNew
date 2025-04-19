extends MarginContainer

signal button_toggled
@onready var texture_rect = $VBoxContainer/TextureRect
@onready var container = $VBoxContainer

@export var texture_link: CompressedTexture2D
@export var texture_unlink: CompressedTexture2D


#func _ready() -> void:
	#get_viewport().connect("size_changed", Callable(self, "_on_viewport_resized"))
#
	#await get_tree().process_frame
	#update_container_position()
#
#func update_container_position() -> void:
	#
	#container.position.x = parent.size.x - catallog_list_container.size.x
	#container.position.y = 0
	#
#func _on_viewport_resized() -> void:
	#await get_tree().process_frame
	#update_container_position()

func _on_check_button_toggled(toggled_on: bool) -> void:
	button_toggled.emit(toggled_on)
	change_icon(toggled_on)

func change_icon(toggled_on: bool) -> void:
	if toggled_on:
		texture_rect.texture = texture_link
	else:
		texture_rect.texture = texture_unlink
