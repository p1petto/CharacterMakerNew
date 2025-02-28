extends Area2D

class_name AccessorieElement
@export var accessorie: Accessorie

@onready var sprite2d = $Sprite2D
@onready var collision_shape = $CollisionShape2D

var cur_down_position: Vector2
var cur_top_position: Vector2
var cur_right_position: Vector2
var cur_left_position: Vector2

var z_down: int
var z_top: int
var z_left: int
var z_right: int

func _ready() -> void:
	cur_down_position = accessorie.start_down_position
	cur_top_position = accessorie.start_top_position
	cur_right_position = accessorie.start_right_position
	cur_left_position = accessorie.start_left_position

	change_direction(Global.current_dir)

	collision_shape.shape.size = sprite2d.texture.get_size()
	
	var child_index = get_index()
	
	match Global.current_dir:
		"down":
			z_down = child_index + 1
			z_top = -(child_index + 1)
			z_right = child_index + 1
			z_left = child_index + 1
			
			z_index = z_down
		"top":
			z_down = -(child_index + 1)
			z_top = child_index + 1
			z_right = child_index + 1
			z_left = child_index + 1
			
			z_index = z_top
		"right":
			z_down = child_index + 1
			z_top = -(child_index + 1)
			z_right = child_index + 1
			z_left = child_index + 1
			
			z_index = z_right
		"left":
			z_down = child_index + 1
			z_top = -(child_index + 1)
			z_right = child_index + 1
			z_left = child_index + 1
			
			z_index = z_left


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func change_direction(dir: String) -> void:
	match dir:
		"down":
			sprite2d.texture = accessorie.down_texture
			position = cur_down_position
			z_index = z_down
		"top":
			sprite2d.texture = accessorie.top_texture
			position = cur_top_position
			z_index = z_top
		"right":
			sprite2d.texture = accessorie.right_texture
			position = cur_right_position
			z_index = z_right
		"left":
			sprite2d.texture = accessorie.left_texture
			position = cur_left_position
			z_index = z_left

	
