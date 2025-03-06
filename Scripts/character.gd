extends Node2D

@export var started_static_elements: Array[CatalogItem] = []
@onready var head_static_elements = $"Head/Polygon2D"
@onready var body_static_elements = $"Body/Polygon2D"

@onready var catallog = $"../../../UI/Catalog/CatalogContainer"
@onready var button_container = $"../../../UI/DirectionButtons"
@onready var head = $Head
@onready var body = $Body
@onready var arm_r = $RightArm
@onready var arm_l = $LeftArm
var cur_frame: int

signal direction_change_sliders

func _ready() -> void:
	for button in button_container.get_children():
		if button.is_in_group("DirectionButton"):
			button.direction_changed.connect(on_direction_changed)
		
	for element in started_static_elements:
		var static_element_scene = preload("res://Scenes/static_element.tscn")
		var static_element = static_element_scene.instantiate()
		static_element.static_resource = element.static_element
		static_element.name = element.item_class
		static_element.change_direction(Global.current_dir)
		head_static_elements.add_child(static_element)
		
	arm_r.idle_ainmation_offset_vertical = body.idle_ainmation_offset_vertical
	arm_l.idle_ainmation_offset_vertical = body.idle_ainmation_offset_vertical
	arm_r.walk_animation_offset_vertical = body.walk_animation_offset_vertical
	arm_l.walk_animation_offset_vertical = body.walk_animation_offset_vertical
	arm_r.idle_ainmation_offset_horizontal = body.idle_ainmation_offset_horizontal
	arm_l.idle_ainmation_offset_horizontal = body.idle_ainmation_offset_horizontal
	arm_r.walk_animation_offset_horizontal = body.walk_animation_offset_horizontal
	arm_l.walk_animation_offset_horizontal = body.walk_animation_offset_horizontal
	
	

func _process(delta: float) -> void:
	pass

func on_direction_changed():
	change_dir_for_parts()
	
	direction_change_sliders.emit(Global.current_dir)
		
func change_dir_for_parts():
	for child in get_children():
		if child.is_in_group("Dynamic"):
			child.setup_polygon(Global.current_dir)
		elif child.is_in_group("ConditionallyDynamic"):
			child.change_direction(Global.current_dir)
	for child in head_static_elements.get_children():
		if child.is_in_group("Static"): 
			child.change_direction(Global.current_dir)
	for child in body_static_elements.get_children():
		if child.is_in_group("Static"): 
			child.change_direction(Global.current_dir)
	for child in head.get_node("Accessories").get_children():
		child.change_direction(Global.current_dir)
		
