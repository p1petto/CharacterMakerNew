extends MarginContainer

class_name CustomTab

@onready var grid = $VBoxContainer/ScrollContainer/GridContainer
@onready var character = $"../../../../SubViewportContainer/SubViewport/Character"

@export var catalog_items: Array[CatalogItem] = []

@export var linked_symmetrical_element: CustomTab

#
#signal part_changed
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
	var current_node 
	
	if item_type == "Dynamic":
		var part = catalog_items[slot_index].dynamic_part	
		current_node = character.get_node(item_class)
		current_node.dynamic_part = part
		# Emit signal first
		change_sliders.emit(item_class)
		# Wait for two frames to ensure sliders are updated
		await get_tree().process_frame
		await get_tree().process_frame
		# Now setup the polygon
		current_node.setup_polygon(character.cur_dir)
		
	elif item_type == "Conditionally_dynamic":
		var part = catalog_items[slot_index].conditionally_dynamic_part
		current_node = character.get_node(item_class)
		current_node.conditionally_dynamic = part
		# Emit signal first
		change_sliders.emit(item_class)
		# Wait for two frames to ensure sliders are updated
		await get_tree().process_frame
		await get_tree().process_frame
		# Now change thickness
		current_node.change_thickness(1)
		
		if current_node.is_symmetrical:
			var linked_part = linked_symmetrical_element.catalog_items[slot_index].conditionally_dynamic_part
			current_node.linked_symmetrical_element.conditionally_dynamic = linked_part
			current_node.linked_symmetrical_element.change_thickness(1)
	
	elif item_type == "Static":
		var part = catalog_items[slot_index].static_element
		current_node = character.get_node(part.target_part)
		current_node = current_node.get_node("Polygon2D")
		current_node = current_node.get_node(item_class)

		current_node.static_resource = catalog_items[slot_index].static_element
		current_node.change_direction(character.cur_dir)
		
		if linked_symmetrical_element:
			var check_button = get_node("VBoxContainer/CustomCheckButton/CheckButton")
			var is_symmetrical = check_button.button_pressed
			if is_symmetrical:
				var linked_part = linked_symmetrical_element.catalog_items[slot_index].static_element
				var linked_item_class = linked_symmetrical_element.catalog_items[slot_index].item_class
			
				var linked_node = character.get_node(part.target_part)
				linked_node = linked_node.get_node("Polygon2D")
				linked_node = linked_node.get_node(linked_item_class)
				linked_node.static_resource = linked_symmetrical_element.catalog_items[slot_index].static_element
				linked_node.change_direction(character.cur_dir)
		
		
		
		
		
			
