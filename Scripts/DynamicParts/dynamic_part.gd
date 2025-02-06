extends Node2D

@export var dynamic_part: DynamicBodyPart

@onready var polygon2d = $Polygon2D
@onready var line2d = $Line2D
@onready var glare = $Polygon2D/glare

func _ready() -> void:
	if dynamic_part:
		polygon2d.polygon = dynamic_part.array_points
		line2d.points = dynamic_part.array_points
		
		if dynamic_part.glare_array_points:
			glare.polygon = dynamic_part.glare_array_points
		
