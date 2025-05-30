extends MarginContainer

signal button_toggled
@onready var texture_rect = $VBoxContainer/TextureRect
@onready var container = $VBoxContainer

@export var texture_link: CompressedTexture2D
@export var texture_unlink: CompressedTexture2D


func _on_check_button_toggled(toggled_on: bool) -> void:
	button_toggled.emit(toggled_on)
	change_icon(toggled_on)

func change_icon(toggled_on: bool) -> void:
	if toggled_on:
		texture_rect.texture = texture_link
	else:
		texture_rect.texture = texture_unlink
