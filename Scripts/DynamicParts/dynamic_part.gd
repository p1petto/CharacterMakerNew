extends Node2D

class_name DynamicBodyPart

@export var dynamic_part: Dynamic

@export var idle_ainmation_offset_vertical: Array[Vector2]
@export var walk_animation_offset_vertical: Array[Vector2]
@export var idle_ainmation_offset_horizontal: Array[Vector2]
@export var walk_animation_offset_horizontal: Array[Vector2]



@onready var polygon2d = $Polygon2D
@onready var testpolygon2d = $Polygon2D
@onready var line2d = $Line2D
@onready var glare = $Polygon2D/glare

@onready var slider_containers = $"../../../../UI/SliderContainer"
@onready var character = $".."
#@onready var clothes = $Polygon2D/Clothes

var flag = true

var color_picker_button
var color_picker_button_border
var cur_color: Color
var initial_line_color: Color
var initial_glare_color: Color

var central_point = 7


func _ready() -> void:
	if dynamic_part:
		setup_polygon("down")
	flag = false
	
	if dynamic_part:
		initial_line_color = dynamic_part.line_color
		initial_glare_color = dynamic_part.glare_color
	
	call_deferred("_connect_color_changed_signal")
	call_deferred("_connect_color")

func _connect_color_changed_signal():
	color_picker_button.color_changed.connect(_on_color_changed)
	color_picker_button_border.color_changed.connect(_on_border_color_changed)
	
	
func _connect_color():
	cur_color = dynamic_part.color
	color_picker_button._on_color_picker_color_changed(cur_color)
	color_picker_button_border._on_color_picker_color_changed(initial_line_color)
	material.set_shader_parameter("cur_color", cur_color)
	
	if polygon2d:
		polygon2d.self_modulate = cur_color
	if line2d:
		line2d.default_color = Color(1,1,1)
	if glare:
		glare.self_modulate = initial_glare_color
		
	set_start_color()

func set_start_color():
	cur_color = dynamic_part.color

	_on_color_changed(cur_color)
	_on_border_color_changed(initial_line_color)
	
	color_picker_button.color_picker.set_color_from_code(cur_color)
	color_picker_button_border.color_picker.set_color_from_code(initial_line_color)
	color_picker_button_border.set_new_bg_color(initial_line_color) 

func _on_color_changed(new_color: Color) -> void:
	cur_color = new_color
	
	if polygon2d:
		polygon2d.self_modulate = cur_color
			
	if glare:
		var new_glare_color = Color(
			initial_glare_color.r + (cur_color.r - initial_glare_color.r) * 0.6,
			initial_glare_color.g + (cur_color.g - initial_glare_color.g) * 0.6,
			initial_glare_color.b + (cur_color.b - initial_glare_color.b) * 0.6,
			initial_glare_color.a
		)
		glare.self_modulate = new_glare_color
		
func _on_border_color_changed(new_color: Color):
	line2d.self_modulate = new_color

func get_target_container_slider():
	var character_part = get_name()
	var cur_dir = Global.current_dir
	var axis
	if cur_dir == "top" or cur_dir == "down":
		axis = "_vertical"
	else:
		axis = "_horizontal"
	var target_container_slider = slider_containers.get_node(character_part+axis)
	return target_container_slider

func setup_polygon(dir) -> void:
	var sliders
	if !flag:
		var slider_window = get_target_container_slider()
		sliders = slider_window.get_node("CenterContainer/VBoxContainer").get_children()
	
	for child in polygon2d.get_children():
		if child.is_in_group("Clothes"):
			child.change_dir()
	
	if dir == "down":
		polygon2d.polygon = dynamic_part.down_array_points
		line2d.points = dynamic_part.down_array_points
		glare.polygon = dynamic_part.down_glare_array_points
		
		position = dynamic_part.position_down
		z_index = dynamic_part.z_down
				
		if !flag:
			for slider in sliders:
				polygon2d.polygon[slider.linked_marker].x = dynamic_part.down_array_points[slider.linked_marker].x - slider.value
				line2d.points[slider.linked_marker].x = dynamic_part.down_array_points[slider.linked_marker].x - slider.value
				var mirror_x = get_mirror_x(len(dynamic_part.down_array_points), slider.linked_marker)
				polygon2d.polygon[mirror_x].x = dynamic_part.down_array_points[mirror_x].x + slider.value
				line2d.points[mirror_x].x = dynamic_part.down_array_points[mirror_x].x + slider.value
		
	if dir == "top":
		polygon2d.polygon = dynamic_part.top_array_points
		line2d.points = dynamic_part.top_array_points
		glare.polygon = dynamic_part.top_glare_array_points
		
		position = dynamic_part.position_top
		z_index = dynamic_part.z_top
				
		if !flag:
			for slider in sliders:
				polygon2d.polygon[slider.linked_marker].x = dynamic_part.top_array_points[slider.linked_marker].x - slider.value
				line2d.points[slider.linked_marker].x = dynamic_part.top_array_points[slider.linked_marker].x - slider.value
				var mirror_x = get_mirror_x(len(dynamic_part.top_array_points), slider.linked_marker)
				polygon2d.polygon[mirror_x].x = dynamic_part.top_array_points[mirror_x].x + slider.value
				line2d.points[mirror_x].x = dynamic_part.top_array_points[mirror_x].x + slider.value			
		
	if dir == "right":
		polygon2d.polygon = dynamic_part.horizontal_array_points
		glare.polygon = dynamic_part.horizontal_glare_array_points
		
		# First update polygon based on sliders
		if !flag:
			for slider in sliders:
				polygon2d.polygon[slider.linked_marker].x += slider.value

		# Now sync line2d with polygon2d
		line2d.points = polygon2d.polygon.duplicate()

		position = dynamic_part.position_right
		z_index = dynamic_part.z_right

	if dir == "left":
		polygon2d.polygon = dynamic_part.horizontal_array_points.duplicate()
		glare.polygon = dynamic_part.horizontal_glare_array_points.duplicate()
		if !flag:
			var slider_window = get_target_container_slider()
			sliders = slider_window.get_node("CenterContainer/VBoxContainer").get_children()
			for slider in sliders:
				polygon2d.polygon[slider.linked_marker].x += slider.value

		var mirrored_points = []
		for point in polygon2d.polygon:
			mirrored_points.append(Vector2(central_point - (point.x - central_point), point.y))
		var mirrored_glare_points = []
		for point in glare.polygon:
			mirrored_glare_points.append(Vector2(central_point - (point.x - central_point), point.y))
		
		polygon2d.polygon = mirrored_points
		glare.polygon = mirrored_glare_points
		line2d.points = polygon2d.polygon.duplicate()
		
		position = dynamic_part.position_left
		z_index = dynamic_part.z_left
		
			
func get_mirror_x(count_of_points, marker):
	if count_of_points % 2 == 0:
		return count_of_points - marker
	return count_of_points - marker - 1
	
	
func initialize_clothes(resource_clothes: Clothes, clothes_name):
	var clothes = polygon2d.get_node(clothes_name)
	clothes.resource_clothes = resource_clothes
	clothes.initialize()
