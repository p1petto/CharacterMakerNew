extends Resource

class_name StaticClothing

@export var parent_node: String = ""
@export var anchor_node: String = ""
@export var sprite_frames: SpriteFrames
@export var sprite_frames_line: SpriteFrames

@export var z_down: int
@export var z_right: int
@export var z_top: int
@export var z_left: int

@export var pos: Vector2

@export var name_clothing: String

@export var initial_color: Color = Color (1, 1, 1)
@export var initial_color_line: Color = Color (1, 1, 1)
