extends Node2D

@export var dynamic_part: DynamicBodyPart


@onready var polygon2d = $Polygon2D
@onready var testpolygon2d = $Polygon2D
@onready var line2d = $Line2D
@onready var glare = $Polygon2D/glare

#var marker_scene = preload("res://Scenes/marker.tscn")
var central_bottom_point: int 

func _ready() -> void:
	if dynamic_part:
		setup_polygon("down")
		
	#for m in dynamic_part.markers:
		#var marker = marker_scene.instantiate()
		#marker.position = polygon2d.polygon[m] * 5 
		#marker_container.add_child(marker)

func setup_polygon(dir) -> void:
	if dir == "down":
		polygon2d.polygon = dynamic_part.down_array_points
		line2d.points = dynamic_part.down_array_points
		glare.polygon = dynamic_part.down_glare_array_points
		
		position.x = dynamic_part.position_x_down
		z_index = dynamic_part.z_down
		
		central_bottom_point = len(dynamic_part.down_array_points) / 2
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
