extends Resource

class_name HairResource

@export var sprite_frames: SpriteFrames
@export var sprite_frames_line: SpriteFrames

@export var pos_down: Vector2
@export var pos_right: Vector2
@export var pos_top: Vector2
@export var pos_left: Vector2

@export var z_down: int
@export var z_right: int
@export var z_top: int
@export var z_left: int

@export var initial_color: Color = Color(1, 1, 1)
@export var initial_color_line: Color = Color(1, 1, 1)

@export_enum("Crown", "Fringe") 
var hair_type: String = "Crown"

@export var quantity: int = 1

@export var has_line: bool = false
