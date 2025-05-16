extends Resource

class_name Accessorie

@export var sprite_frames: SpriteFrames
@export var sprite_frames_line: SpriteFrames

@export var texture_icon: CompressedTexture2D

@export var start_down_position: Vector2
@export var start_top_position: Vector2
@export var start_right_position: Vector2
@export var start_left_position: Vector2

@export var min_x_vertical: float
@export var max_x_vertical: float
@export var min_y_vertical: float
@export var max_y_vertical: float

@export var min_x_left: float
@export var max_x_left: float
@export var min_y_left: float
@export var max_y_left: float

@export var min_x_right: float
@export var max_x_right: float
@export var min_y_right: float
@export var max_y_right: float

@export var can_top: bool = true
@export var can_flip_on_horizontal: bool = true

@export var color: Color
@export var line_color: Color = Color("1b1b1b")

@export var has_line: bool = false
