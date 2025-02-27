extends MarginContainer

class_name CustomTab

@onready var grid = $VBoxContainer/ScrollContainer/GridContainer
@onready var character = $"../../../../SubViewportContainer/SubViewport/Character"

@export var catalog_items: Array[CatalogItem] = []

@export var linked_symmetrical_element: CustomTab

signal change_sliders

func _ready() -> void:
	for item in catalog_items:
		add_catalog_item(item)

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
	print("Pressed catalog slot index: ", slot_index)
	var item_class = catalog_items[slot_index].item_class
	var item_type = catalog_items[slot_index].item_type

	match item_type:
		"Dynamic":
			_handle_dynamic_item(slot_index, item_class)
		"Conditionally_dynamic":
			_handle_conditionally_dynamic_item(slot_index, item_class)
		"Static":
			_handle_static_item(slot_index, item_class)
		"Accessories":
			_handle_accessories_item(slot_index, item_class)

func _handle_dynamic_item(slot_index, item_class):
	var part = catalog_items[slot_index].dynamic_part	
	var current_node = character.get_node(item_class)
	current_node.dynamic_part = part
	change_sliders.emit(item_class)
	await get_tree().process_frame
	await get_tree().process_frame
	current_node.setup_polygon(Global.current_dir)

func _handle_conditionally_dynamic_item(slot_index, item_class):
	var part = catalog_items[slot_index].conditionally_dynamic_part
	var current_node = character.get_node(item_class)
	current_node.conditionally_dynamic = part
	change_sliders.emit(item_class)
	await get_tree().process_frame
	await get_tree().process_frame
	current_node.change_thickness(1)

	if current_node.is_symmetrical:
		var linked_part = linked_symmetrical_element.catalog_items[slot_index].conditionally_dynamic_part
		current_node.linked_symmetrical_element.conditionally_dynamic = linked_part
		current_node.linked_symmetrical_element.change_thickness(1)

func _handle_static_item(slot_index, item_class):
	var part = catalog_items[slot_index].static_element
	var current_node = character.get_node(part.target_part)
	current_node = current_node.get_node("Polygon2D").get_node(item_class)

	current_node.static_resource = catalog_items[slot_index].static_element
	current_node.position = current_node.static_resource.start_position
	current_node.static_resource.cur_position = current_node.static_resource.start_position
	current_node.change_direction(Global.current_dir)

	if linked_symmetrical_element:
		var check_button = get_node("VBoxContainer/CustomCheckButton/CheckButton")
		if check_button.button_pressed:
			var linked_part = linked_symmetrical_element.catalog_items[slot_index].static_element
			var linked_item_class = linked_symmetrical_element.catalog_items[slot_index].item_class
			var linked_node = character.get_node(part.target_part)
			linked_node = linked_node.get_node("Polygon2D").get_node(linked_item_class)
			linked_node.static_resource = linked_part
			linked_node.position = linked_node.static_resource.start_position
			linked_node.static_resource.cur_position = linked_node.static_resource.start_position
			linked_node.change_direction(Global.current_dir)
			
func _handle_accessories_item(slot_index, item_class):
	var part = catalog_items[slot_index].accessorie
	
	if Global.current_dir == "top" and "not_can_top":
		return
		
	var current_node = character.get_node("Head/Accessories")

	var accessory_scene = preload("res://Scenes/accessorie.tscn")
	var accessory_instance = accessory_scene.instantiate()

	var accessory_number = current_node.get_child_count()
	accessory_instance.name = "Accessorie_" + str(accessory_number)
	accessory_instance.accessorie = part

	current_node.add_child(accessory_instance)

	
