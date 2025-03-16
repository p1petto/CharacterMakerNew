extends Node2D

@export var dynamic_part: DynamicBodyPart

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
@onready var clothes = $Polygon2D/Clothes

var central_bottom_point: int 
var flag = true

var color_picker_button
var cur_color: Color
var initial_line_color: Color
var initial_glare_color: Color


func _ready() -> void:
	if dynamic_part:
		setup_polygon("down")
	flag = false
	
	# Store initial colors
	if dynamic_part:
		initial_line_color = dynamic_part.line_color
		initial_glare_color = dynamic_part.glare_color
	
	call_deferred("_connect_color_changed_signal")
	call_deferred("_connect_color")

func _connect_color_changed_signal():
	color_picker_button.color_changed.connect(_on_color_changed)
	
	
func _connect_color():
	cur_color = dynamic_part.color
	color_picker_button._on_color_picker_color_changed(cur_color)
	material.set_shader_parameter("cur_color", cur_color)
	
	# Set initial colors for all elements
	if polygon2d:
		polygon2d.color = cur_color
	if line2d:
		line2d.default_color = initial_line_color
	if glare:
		glare.color = initial_glare_color
		
	color_picker_button.color_picker.color = cur_color
	set_start_color()

func set_start_color():
	cur_color = dynamic_part.color
	if material:
		material.set_shader_parameter("cur_color", cur_color)
	
	# Reset polygon2d to exact color from color picker
	if polygon2d:
		polygon2d.color = cur_color
	
	# Reset line2d to its initial color
	if line2d:
		line2d.default_color = initial_line_color
	
	# Reset glare to its initial color
	if glare:
		glare.color = initial_glare_color
	_on_color_changed(cur_color)
	color_picker_button.color_picker.color = cur_color

func _on_color_changed(new_color: Color) -> void:
	cur_color = new_color
	
	# Apply shader to material if exists
	if material:
		material.set_shader_parameter("cur_color", cur_color)
	
	# For Polygon2D - directly set to the color picker value
	if polygon2d:
		polygon2d.color = cur_color
	
	# For Line2D - blend the initial line color with the new color
	var new_line_color = Color(
			initial_line_color.r + (cur_color.r - initial_line_color.r) * 0.3,
			initial_line_color.g + (cur_color.g - initial_line_color.g) * 0.3,
			initial_line_color.b + (cur_color.b - initial_line_color.b) * 0.3,
			initial_line_color.a
		)

	line2d.default_color = new_line_color
	
	# For Glare - blend the initial glare color with the new color
	if glare:
		var new_glare_color = Color(
			initial_glare_color.r + (cur_color.r - initial_glare_color.r) * 0.6,
			initial_glare_color.g + (cur_color.g - initial_glare_color.g) * 0.6,
			initial_glare_color.b + (cur_color.b - initial_glare_color.b) * 0.6,
			initial_glare_color.a
		)
		glare.color = new_glare_color

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
		sliders = get_target_container_slider().get_children()
	
	clothes.change_dir()
	
	if dir == "down":
		polygon2d.polygon = dynamic_part.down_array_points
		line2d.points = dynamic_part.down_array_points
		glare.polygon = dynamic_part.down_glare_array_points
		
		position = dynamic_part.position_down
		z_index = dynamic_part.z_down
		
		central_bottom_point = len(dynamic_part.down_array_points) / 2
		
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
		
		central_bottom_point = len(dynamic_part.top_array_points) / 2
		
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

		central_bottom_point = len(dynamic_part.horizontal_array_points) / 2

	if dir == "left":
		# Start with original horizontal points
		polygon2d.polygon = dynamic_part.horizontal_array_points.duplicate()
		glare.polygon = dynamic_part.horizontal_glare_array_points.duplicate()
		
		# Apply slider changes (similar to right direction)
		if !flag:
			sliders = get_target_container_slider().get_children()
			for slider in sliders:
				polygon2d.polygon[slider.linked_marker].x += slider.value
		
		# Mirror all polygon points
		var mirrored_points = []
		for point in polygon2d.polygon:
			mirrored_points.append(Vector2(7 - (point.x - 7), point.y))
		
		# Mirror glare points
		var mirrored_glare_points = []
		for point in glare.polygon:
			mirrored_glare_points.append(Vector2(7 - (point.x - 7), point.y))
		
		# Apply mirrored coordinates
		polygon2d.polygon = mirrored_points
		glare.polygon = mirrored_glare_points
		line2d.points = polygon2d.polygon.duplicate()
		
		position = dynamic_part.position_left
		z_index = dynamic_part.z_left
		
		central_bottom_point = len(dynamic_part.horizontal_array_points) / 2

			
func get_mirror_x(count_of_points, marker):
	if count_of_points % 2 == 0:
		return count_of_points - marker
	return count_of_points - marker - 1
	
	
func initialize_clothes(resource_clothes: Clothes):
	clothes.resource_clothes = resource_clothes
	clothes.initialize()
