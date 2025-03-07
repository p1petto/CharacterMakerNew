extends Container

@onready var catalog = $"../Catalog"  # Получаем ссылку на каталог
var color_picker_button_scene = preload("res://Scenes/UI/custom_color_picker_button.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Создаём кнопки для каждого дочернего элемента в catalog
	for child in catalog.get_node("CatalogContainer").get_children():
		if !child.is_in_group("Accessorie"):
			var color_picker_button = color_picker_button_scene.instantiate()
			color_picker_button.name = child.name  
			color_picker_button.size = Vector2(40,30)
			add_child(color_picker_button)
			color_picker_button.visible = false
