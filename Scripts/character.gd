extends Node2D

@export var started_static_elements: Array[CatalogItem] = []
@onready var head_static_elements = $"Head/Polygon2D"
@onready var body_static_elements = $"Body/Polygon2D"

@onready var catallog = $"../../../UI/Catalog/CatalogContainer"
@onready var button_container = $"../../../UI/DirectionButtons"
@onready var head = $Head

var cur_dir = "down"


signal direction_change_sliders

func _ready() -> void:
	for button in button_container.get_children():
		if button.is_in_group("DirectionButton"):
			button.direction_changed.connect(_on_direction_changed)
		
	for element in started_static_elements:
		var static_element_scene = preload("res://Scenes/static_element.tscn")
		var static_element = static_element_scene.instantiate()
		static_element.static_resource = element.static_element
		static_element.name = element.item_class
		static_element.change_direction(cur_dir)
		head_static_elements.add_child(static_element)
	
	

func _process(delta: float) -> void:
	pass

func _on_direction_changed(dir):
	if cur_dir != dir:
		cur_dir = dir
		Global.current_dir = dir
		print ("current direction = ", cur_dir)
		change_dir_for_parts()
		direction_change_sliders.emit(cur_dir)
		
func change_dir_for_parts():
	for child in get_children():
		if child.is_in_group("Dynamic"):
			child.setup_polygon(cur_dir)
		elif child.is_in_group("ConditionallyDynamic"):
			child.change_direction(cur_dir)
	for child in head_static_elements.get_children():
		if child.is_in_group("Static"): 
			child.change_direction(cur_dir)
	for child in body_static_elements.get_children():
		if child.is_in_group("Static"): 
			child.change_direction(cur_dir)
	for child in head.get_node("Accessories").get_children():
		child.change_direction(cur_dir)
		
