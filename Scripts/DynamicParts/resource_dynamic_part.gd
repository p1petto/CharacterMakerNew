extends Resource

class_name  DynamicBodyPart

@export var down_array_points: PackedVector2Array
@export var horizontal_array_points: PackedVector2Array
@export var top_array_points: PackedVector2Array

@export var down_glare_array_points: PackedVector2Array
@export var horizontal_glare_array_points: PackedVector2Array
@export var top_glare_array_points: PackedVector2Array

@export var position_down: Vector2
@export var position_right: Vector2
@export var position_top: Vector2
@export var position_left: Vector2

@export var z_down: float
@export var z_right: float
@export var z_top: float
@export var z_left: float

@export var vertical_markers: Array[int]
@export var horizontal_markers: Array[int]

@export var hand_marker_for_body: int

@export var color: Color
@export var glare_color: Color
@export var line_color: Color
