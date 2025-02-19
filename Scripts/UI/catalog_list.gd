extends MarginContainer

class_name CustomTab

@onready var grid = $VBoxContainer/ScrollContainer/GridContainer
@onready var character = $"../../../../SubViewportContainer/SubViewport/Character"

@export var catalog_items: Array[CatalogItem] = []


signal part_changed
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
	var item_type =  catalog_items[slot_index].item_type
	var current_node = character.get_node(item_class)
	
	if item_type == "Dynamic":
		var part = catalog_items[slot_index].dynamic_part	
		current_node.dynamic_part = part
		part_changed.emit(current_node, item_type)
		
	elif item_type == "Conditionally_dynamic":
		var part = catalog_items[slot_index].conditionally_dynamic_part
		current_node.conditionally_dynamic = part
		part_changed.emit(current_node, item_type)
		
	change_sliders.emit(item_class)
