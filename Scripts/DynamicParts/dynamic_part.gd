extends Node2D

@export var dynamic_part: DynamicBodyPart


@onready var polygon2d = $Polygon2D
@onready var testpolygon2d = $Polygon2D
@onready var line2d = $Line2D
@onready var glare = $Polygon2D/glare

#var marker_scene = preload("res://Scenes/marker.tscn")

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
	if dir == "right":
		polygon2d.polygon = dynamic_part.horizontal_array_points
		line2d.points = dynamic_part.horizontal_array_points
		
		glare.polygon = dynamic_part.horizontal_glare_array_points
