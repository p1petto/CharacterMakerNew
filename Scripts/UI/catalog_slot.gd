extends TextureButton

@onready var texture_rect = $MarginContainer/CenterContainer/TextureRect

@export var item: CatalogItem

signal slot_pressed
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if item.icon:
		texture_rect.texture = item.icon

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_down() -> void:
	slot_pressed.emit()
