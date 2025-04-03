extends Resource

class_name HairResource

@export var sprite_frames: SpriteFrames

@export var pos_down: Vector2
@export var pos_right: Vector2
@export var pos_top: Vector2
@export var pos_left: Vector2
@export var initial_color: Color = Color(1, 1, 1)

@export_enum("Crown") 
var hair_type: String = "Crown"

@export var quantity: int = 1
