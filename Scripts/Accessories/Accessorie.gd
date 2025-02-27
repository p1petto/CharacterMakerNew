extends Sprite2D

@export var accessorie: Accessorie

var cur_down_position: Vector2
var cur_top_position: Vector2
var cur_right_position: Vector2
var cur_left_position: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position = accessorie.start_down_position
	cur_down_position = accessorie.start_down_position
	cur_top_position = accessorie.start_top_position
	cur_right_position = accessorie.start_right_position
	cur_left_position = accessorie.start_left_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func change_direction(dir: String) -> void:
	match dir:
		"down":
			texture = accessorie.down_texture
			position = cur_down_position
		"top":
			texture = accessorie.top_texture
			position = cur_top_position
		"right":
			texture = accessorie.right_texture
			position = cur_right_position
		"left":
			texture = accessorie.left_texture
			position = cur_left_position

	
