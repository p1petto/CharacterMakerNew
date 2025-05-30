extends TextureButton

@onready var texture_rect = $MarginContainer/CenterContainer/TextureRect

@export var item: CatalogItem

signal slot_pressed

func _ready() -> void:
	if item.icon:
		texture_rect.texture = item.icon


func _on_button_down() -> void:
	slot_pressed.emit()
