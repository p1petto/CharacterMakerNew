extends Container

@onready var catalog = $"../../.."
@onready var character = $"../../../../../SubViewportContainer/SubViewport/Character"
@onready var button_scroll_container = $"../ButtonsScrollContainer"
@onready var color_scheme_controller = $"../../../CatalogContainer/ColorSettings/CenterContainer/ColorSchemeController"
var color_picker_button_scene = preload("res://Scenes/UI/custom_color_picker_button.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Создаём кнопки для каждого дочернего элемента в catalog
	for child in catalog.get_node("CatalogContainer").get_children():
		if !child.is_in_group("Accessorie") and !child.is_in_group("SettingsTab"):
			_create_and_assign_color_picker(child)

func _create_and_assign_color_picker(child) -> void:
	var color_picker_button = color_picker_button_scene.instantiate()
	color_picker_button.name = child.name  
	color_picker_button.size = Vector2(40, 30)
	
	add_child(color_picker_button)
	color_picker_button.visible = false
	
	var character_element
	if child.is_in_group("DynamicClothesTab"):
		var target_node = child.catalog_items[0].item_class
		target_node = character.find_child(target_node, true, false)
		if child.catalog_items[0].dynamic_clothes.is_flooded_inside:
			character_element = target_node.find_child("DynamicClothes", true, false)
		else:
			character_element = target_node.find_child("TipWear", true, false)
		character_element.color_picker_button = color_picker_button
		character_element._connect_color_changed_signal()
		character_element._connect_color()
		color_scheme_controller.clothes_buttons.append(color_picker_button)
	elif child.is_in_group("ClothesTab"):
		var target_node = child.catalog_items[0].item_class
		target_node = character.find_child(target_node, true, false)
		var polygon2d = target_node.find_child("Polygon2D", true, false)
		character_element = polygon2d.find_child(child.name, true, false)
		character_element.color_picker_button = color_picker_button
		character_element._connect_color_changed_signal()
		character_element._connect_color()
		color_scheme_controller.clothes_buttons.append(color_picker_button)
	else:
		character_element = character.find_child(child.name, true, false)
		character_element.color_picker_button = color_picker_button
		color_scheme_controller.body_buttons.append(color_picker_button)

			
			
