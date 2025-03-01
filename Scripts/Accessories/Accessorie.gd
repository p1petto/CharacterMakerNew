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

var accessorie_button: AccessorieButton

func _ready() -> void:
	cur_down_position = accessorie.start_down_position
	cur_top_position = accessorie.start_top_position
	cur_right_position = accessorie.start_right_position
	cur_left_position = accessorie.start_left_position

	change_direction(Global.current_dir)

	collision_shape.shape.size = sprite2d.texture.get_size()
	
	var child_index = get_index()
	

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
			
func move_accesorie_element(val: Vector2) -> void:
	print("val", val)
	if cur_down_position.x + val.x >= accessorie.min_x_vertical and cur_down_position.x + val.x <= accessorie.max_x_vertical and cur_down_position.y + val.y >= accessorie.min_y_vertical and cur_down_position.y + val.y <= accessorie.max_y_vertical:
		cur_down_position = cur_down_position + val
	if cur_top_position.x + val.x >= accessorie.min_x_vertical and cur_top_position.x + val.x <= accessorie.max_x_vertical and cur_top_position.y + val.y >= accessorie.min_y_vertical and cur_top_position.y + val.y <= accessorie.max_y_vertical:
		cur_top_position = cur_top_position + val
	if cur_right_position.x + val.x >= accessorie.min_x_right and cur_right_position.x + val.x <= accessorie.max_x_right and  cur_right_position.y + val.y >= accessorie.min_y_right and cur_right_position.y + val.y <= accessorie.max_y_right:
		cur_right_position = cur_right_position + val
	if cur_left_position.x + val.x >= accessorie.min_x_left and cur_left_position.x + val.x <= accessorie.max_x_left and cur_left_position.y + val.y >= accessorie.min_y_left and cur_left_position.y + val.y <= accessorie.max_y_left:
		cur_left_position = cur_left_position + val
	
	
	change_direction(Global.current_dir)
			
