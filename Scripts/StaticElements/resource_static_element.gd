extends Resource

class_name Static

@export var sprite_frames: SpriteFrames
@export var start_position: Vector2

@export var min_x: int
@export var min_y: int
@export var max_x: int
@export var max_y: int

@export_enum("Body", "Head") 
var target_part: String = "Body"

@export var color: Color

var cur_position: Vector2 = start_position
