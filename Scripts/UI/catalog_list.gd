extends MarginContainer

class_name CustomTab

@onready var grid = $VBoxContainer/ScrollContainer/GridContainer
@onready var character = $"../../../../SubViewportContainer/SubViewport/Character"
@onready var accecorie_panel = $"../../../AccessoriePanel"
@onready var strand_panel = $"../../../StrandPanel"
@onready var box_container = $VBoxContainer
@export var catalog_items: Array[CatalogItem] = []
@export var linked_symmetrical_element: CustomTab
@export var icon: CompressedTexture2D



signal change_sliders

func _ready() -> void:
		
	for item in catalog_items:
		add_catalog_item(item)
		
	#await get_tree().process_frame  # ждём, чтобы все размеры точно обновились
	#
	#var parent_size = size  # т.к. скрипт на Container (который сам Control)
	#var box_size = box_container.size
	#
	#box_container.position.x = (parent_size.x - box_size.x) / 2
	#box_container.position.y = parent_size.y - box_size.y + 24

func _process(delta: float) -> void:
	pass

func add_catalog_item(item):
	var catalog_slot_scene = preload("res://Scenes/UI/CatalogSlot.tscn")
	var catalog_slot = catalog_slot_scene.instantiate()
	catalog_slot.item = item
	catalog_slot.slot_pressed.connect(_on_catalog_slot_pressed.bind(catalog_slot))
	grid.add_child(catalog_slot)

func _on_catalog_slot_pressed(slot):
	var slot_index = slot.get_index()
	var item_class = catalog_items[slot_index].item_class
	var item_type = catalog_items[slot_index].item_type
	

	match item_type:
		"Dynamic":
			_handle_dynamic_item(slot_index, item_class)
			#update_color.emit(new_bg_color_button)
		"Conditionally_dynamic":
			_handle_conditionally_dynamic_item(slot_index, item_class)
			#update_color.emit(new_bg_color_button)
		"Static":
			_handle_static_item(slot_index, item_class)
			#update_color.emit(new_bg_color_button)
		"Accessories":
			_handle_accessories_item(slot_index, item_class)
			
		"Dynamic_clothes":
			_handle_dynamic_clothes_item(slot_index, item_class)
			
		"Clothes":
			_handle_clothes_item(slot_index, item_class)
			
		"Static_Clothing":
			_handle_static_clothes_item(slot_index, item_class)
			
		"Hair":
			_handle_hair_item(slot_index, item_class)
		"HairStrand":
			_handle_strand_item(slot_index, item_class)

func _handle_dynamic_item(slot_index, item_class):
	var part = catalog_items[slot_index].dynamic_part	
	var current_node = character.get_node(item_class)
	var new_bg_color_button = catalog_items[slot_index].dynamic_part.color
	current_node.dynamic_part = part
	change_sliders.emit(item_class)
	await get_tree().process_frame
	await get_tree().process_frame
	current_node.setup_polygon(Global.current_dir)
	current_node.color_picker_button.set_new_bg_color(new_bg_color_button)
	current_node.set_start_color()


func _handle_conditionally_dynamic_item(slot_index, item_class):
	var part = catalog_items[slot_index].conditionally_dynamic_part
	var current_node = character.get_node(item_class)
	var new_bg_color_button = catalog_items[slot_index].conditionally_dynamic_part.color
	current_node.conditionally_dynamic = part
	change_sliders.emit(item_class)
	await get_tree().process_frame
	await get_tree().process_frame
	current_node.change_thickness(1)

	if current_node.is_symmetrical:
		var linked_part = linked_symmetrical_element.catalog_items[slot_index].conditionally_dynamic_part
		current_node.linked_symmetrical_element.conditionally_dynamic = linked_part
		current_node.linked_symmetrical_element.change_thickness(1)
		
	current_node.color_picker_button.set_new_bg_color(new_bg_color_button)
	current_node.set_start_color()

func _handle_static_item(slot_index, item_class):
	var part = catalog_items[slot_index].static_element
	var current_node = character.get_node(part.target_part)
	var new_bg_color_button = catalog_items[slot_index].static_element.color
	current_node = current_node.get_node("Polygon2D").get_node(item_class)

	current_node.static_resource = catalog_items[slot_index].static_element
	current_node.position = current_node.static_resource.start_position
	current_node.static_resource.cur_position = current_node.static_resource.start_position
	current_node.change_direction(Global.current_dir)

	if linked_symmetrical_element:
		var check_button = get_node("CustomCheckButton/CheckButton")
		if check_button.button_pressed:
			var linked_part = linked_symmetrical_element.catalog_items[slot_index].static_element
			var linked_item_class = linked_symmetrical_element.catalog_items[slot_index].item_class
			var linked_node = character.get_node(part.target_part)
			linked_node = linked_node.get_node("Polygon2D").get_node(linked_item_class)
			linked_node.static_resource = linked_part
			linked_node.position = linked_node.static_resource.start_position
			linked_node.static_resource.cur_position = linked_node.static_resource.start_position
			linked_node.change_direction(Global.current_dir)
			
	current_node.color_picker_button.set_new_bg_color(new_bg_color_button)
	current_node.set_start_color()
			
func _handle_accessories_item(slot_index, item_class):
	var part = catalog_items[slot_index].accessorie
	
	if Global.current_dir == "top" and catalog_items[slot_index].accessorie.not_can_top:
		return
		
	var current_node = character.get_node("Head/Accessories")

	var accessory_scene = preload("res://Scenes/accessorie.tscn")
	var accessory_instance = accessory_scene.instantiate()

	var accessory_number = current_node.get_child_count()
	accessory_instance.name = "Accessorie_" + str(accessory_number)
	accessory_instance.accessorie = part
	current_node.add_child(accessory_instance)
	
	#var button_scene = preload("res://Scenes/UI/AccessoreButton.tscn")
	#var button_instance = button_scene.instantiate()
	#button_instance.accessorie = part
	#accecorie_panel.add_accessorie_button(button_instance)
	accecorie_panel.add_accessorie_button(part, accessory_instance)
	
	#added_accessorie.emit()


func _handle_dynamic_clothes_item(slot_index, item_class):
	var part = catalog_items[slot_index].dynamic_clothes
	var current_node = character.get_node(item_class)
	current_node.initialize_dynamic_clothes(part)
	
	if linked_symmetrical_element:
		var check_button = get_node("CustomCheckButton/CheckButton")
		if check_button.button_pressed:
			var linked_part = linked_symmetrical_element.catalog_items[slot_index].dynamic_clothes
			var linked_item_class = linked_symmetrical_element.catalog_items[slot_index].item_class
			var linked_node = character.get_node(linked_item_class)
			linked_node.initialize_dynamic_clothes(linked_part)
			
		
func _handle_clothes_item(slot_index, item_class):
	var part = catalog_items[slot_index].clothes
	var current_node = character.get_node(item_class)
	
	current_node.initialize_clothes(part, part.clothes_type)
	
	
func _handle_static_clothes_item(slot_index, item_class):
	var resource_part = catalog_items[slot_index].static_clothing
	var parent_node = character
	if catalog_items[slot_index].static_clothing.anchor_node:
		parent_node.get_node(catalog_items[slot_index].static_clothing.anchor_node)
		
	var current_node = parent_node.get_node(catalog_items[slot_index].static_clothing.name_clothing)
	current_node.resource_clothing = resource_part
	current_node.initialize()
	
func _handle_hair_item(slot_index, item_class):
	
	var resource_part = catalog_items[slot_index].hair
	var target_node
	match resource_part.hair_type:
		"Crown":
			target_node = character.head.polygon2d.get_node("Crown")
			target_node.hair_resource = resource_part
			target_node.initialize()
		"Fringe":
			target_node = character.head.get_node("Fringe")
			print("target_node ", target_node.name)
			target_node.hair_resource = resource_part
			target_node.initialize()
	change_sliders.emit(resource_part.hair_type)


func _handle_strand_item(slot_index, item_class):
	var part = catalog_items[slot_index].accessorie
	
	if Global.current_dir == "top" and catalog_items[slot_index].accessorie.not_can_top:
		return
		
	var current_node = character.get_node("Head/Strands")

	var accessory_scene = preload("res://Scenes/accessorie.tscn")
	var strand_instance = accessory_scene.instantiate()

	var strand_number = current_node.get_child_count()
	strand_instance.name = "Strand_" + str(strand_number)
	strand_instance.accessorie = part
	strand_instance.add_to_group("Accessorie")
	current_node.add_child(strand_instance)
	
	strand_panel.add_accessorie_button(part, strand_instance)
