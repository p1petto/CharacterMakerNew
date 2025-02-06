extends Node2D

@export var dynamic_part: DynamicBodyPart

@onready var polygon2d = $Polygon2D
@onready var line2d = $Line2D

func _ready() -> void:
	if dynamic_part:
		polygon2d.polygon = dynamic_part.array_points
		line2d.points = dynamic_part.array_points
		
