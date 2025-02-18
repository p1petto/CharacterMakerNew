extends Node2D

@export var dynamic_part: DynamicBodyPart


@onready var polygon2d = $Polygon2D
@onready var testpolygon2d = $Polygon2D
@onready var line2d = $Line2D
@onready var glare = $Polygon2D/glare

@onready var slider_containers = $"../../../../UI/SliderContainer"
@onready var character = $".."

#var marker_scene = preload("res://Scenes/marker.tscn")
var central_bottom_point: int 
var flag = true

func _ready() -> void:
	if dynamic_part:
		setup_polygon("down")
	flag = false	
	#for m in dynamic_part.markers:
		#var marker = marker_scene.instantiate()
		#marker.position = polygon2d.polygon[m] * 5 
		#marker_container.add_child(marker)
		
func get_target_container_slider():
	var character_part = get_name()
	var cur_dir = character.cur_dir
	var axis
	if cur_dir == "top" or "down":
		axis = "_vertical"
	else:
		axis = "_horizontal"
	var target_container_slider = slider_containers.get_node(character_part+axis)
	return target_container_slider

func setup_polygon(dir) -> void:
	var sliders
	if !flag:
		sliders = get_target_container_slider().get_children()
	if dir == "down":
		polygon2d.polygon = dynamic_part.down_array_points
		line2d.points = dynamic_part.down_array_points
		glare.polygon = dynamic_part.down_glare_array_points
		
		position.x = dynamic_part.position_x_down
		z_index = dynamic_part.z_down
		
		central_bottom_point = len(dynamic_part.down_array_points) / 2
		
		if !flag:
			for slider in sliders:
				polygon2d.polygon[slider.linked_marker].x = dynamic_part.down_array_points[slider.linked_marker].x - slider.value
				line2d.points[slider.linked_marker].x = dynamic_part.down_array_points[slider.linked_marker].x - slider.value

			
				
		
	if dir == "top":
		polygon2d.polygon = dynamic_part.top_array_points
		line2d.points = dynamic_part.top_array_points
		glare.polygon = dynamic_part.top_glare_array_points
		
		position.x = dynamic_part.position_x_top
		z_index = dynamic_part.z_top
		
		central_bottom_point = len(dynamic_part.top_array_points) / 2
	if dir == "right":
		polygon2d.polygon = dynamic_part.horizontal_array_points
		line2d.points = dynamic_part.horizontal_array_points
		glare.polygon = dynamic_part.horizontal_glare_array_points
		
		position.x = dynamic_part.position_x_right
		z_index = dynamic_part.z_right
		
		central_bottom_point = len(dynamic_part.horizontal_array_points) / 2
	if dir == "left":
		var mirrored_points = []
		var mirrored_glare_points = []
		
		# Mirror horizontal points around x=7
		for point in dynamic_part.horizontal_array_points:
			mirrored_points.append(Vector2(7 - (point.x - 7), point.y))
		
		# Mirror glare points around x=7
		for point in dynamic_part.horizontal_glare_array_points:
			mirrored_glare_points.append(Vector2(7 - (point.x - 7), point.y))
		
		polygon2d.polygon = mirrored_points
		line2d.points = mirrored_points
		glare.polygon = mirrored_glare_points
		
		position.x = dynamic_part.position_x_left
		z_index = dynamic_part.z_left
		
		central_bottom_point = len(dynamic_part.horizontal_array_points) / 2
