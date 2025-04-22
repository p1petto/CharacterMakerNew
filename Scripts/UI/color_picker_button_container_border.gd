extends Container

@onready var catalog = $"../../../.."
@onready var character = $"../../../../../../SubViewportContainer/SubViewport/Character"
@onready var button_scroll_container = $"../../ButtonsScrollContainer"
@onready var color_scheme_controller = $"../../../../CatalogContainer/ColorSettings/CenterContainer/ColorSchemeController"
var color_picker_button_scene = preload("res://Scenes/UI/custom_color_picker_button.tscn")

func _ready() -> void:
	for child in catalog.get_node("CatalogContainer").get_children():
		if child.is_in_group("ConditionallyDynamicTab") or child.is_in_group("DynamicTab"):
			_create_and_assign_color_picker(child)
		#elif child.is_in_group("HairTab"):
			#if child.catalog_items[0].hair.has_line:
				#_create_and_assign_color_picker(child)

func _create_and_assign_color_picker(child) -> void:
	var color_picker_button = color_picker_button_scene.instantiate()
	color_picker_button.name = child.name  
	color_picker_button.size = Vector2(30, 30)
	
	add_child(color_picker_button)
	color_picker_button.visible = false
	
	var character_element
	character_element = character.find_child(child.name, true, false)
	character_element.color_picker_button_border = color_picker_button

func _create_and_assign_color_picker_deferred(element):
	var color_picker_button = color_picker_button_scene.instantiate()
	color_picker_button.name = element.name  
	color_picker_button.size = Vector2(30, 30)
	
	
	add_child(color_picker_button)
	color_picker_button.visible = false
	element.color_picker_button_line = color_picker_button
	#element.color_picker_button_line.color_changed.connect(_on_line_color_changed)
