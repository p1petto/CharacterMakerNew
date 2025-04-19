extends Area2D

class_name AccessorieElement
@export var accessorie: Accessorie

@onready var base = $base
@onready var line = $line
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
var color_picker_button
var color_picker_button_line
var cur_color: Color
var start_color: Color

var flip = false

func _ready() -> void:
	cur_down_position = accessorie.start_down_position
	cur_top_position = accessorie.start_top_position
	cur_right_position = accessorie.start_right_position
	cur_left_position = accessorie.start_left_position

	change_direction(Global.current_dir)

	var child_index = get_index()
	
	call_deferred("_connect_color_changed_signal")
	call_deferred("_connect_color")
	
	base.sprite_frames = accessorie.sprite_frames
	if accessorie.has_line:
		line.sprite_frames = accessorie.sprite_frames_line
	

func _connect_color_changed_signal():
	color_picker_button.color_changed.connect(_on_color_changed)
	if accessorie.has_line:
		color_picker_button_line.color_changed.connect(_on_color_line_changed)
func _connect_color():
	cur_color = accessorie.color
	color_picker_button._on_color_picker_color_changed(cur_color)
	color_picker_button.color_picker.color = cur_color
	start_color = cur_color
	material.set_shader_parameter("oldcolor", cur_color)
	set_start_color()
	
func set_start_color() -> void:
	cur_color = start_color
	_on_color_changed(cur_color)
	_on_color_line_changed(accessorie.line_color)
	
func _on_color_changed(new_color: Color) -> void:

	cur_color = new_color
	base.modulate = cur_color 
	
func _on_color_line_changed(new_color: Color) -> void:
	line.modulate = new_color

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func change_direction(dir: String) -> void:
	base.animation = Global.current_dir
	if accessorie.has_line:
		line.animation = Global.current_dir
	match dir:
		"down":
			position = cur_down_position
			z_index = z_down
			update_z_index()
			if flip:
				base.flip_h = true
				line.flip_h = true
			else:
				base.flip_h = false
				line.flip_h = false
		"top":
			position = cur_top_position
			z_index = z_top
			if flip:
				base.flip_h = true
				line.flip_h = true
			else:
				base.flip_h = false
				line.flip_h = false
		"right":
			position = cur_right_position
			z_index = z_right
			if flip and !accessorie.can_flip_on_horizontal:
				base.flip_h = false
				line.flip_h = false
			elif flip:
				base.flip_h = true
				line.flip_h = true
			else:
				base.flip_h = false
				line.flip_h = false
		"left":
			position = cur_left_position
			z_index = z_left
			if flip and !accessorie.can_flip_on_horizontal:
				base.flip_h = false
				line.flip_h = false
			elif flip:
				base.flip_h = true
				line.flip_h = true
			else:
				base.flip_h = false
				line.flip_h = false
	
	
			
func move_accesorie_element(val: Vector2) -> void:
	if cur_down_position.x + val.x >= accessorie.min_x_vertical and cur_down_position.x + val.x <= accessorie.max_x_vertical and cur_down_position.y + val.y >= accessorie.min_y_vertical and cur_down_position.y + val.y <= accessorie.max_y_vertical:
		cur_down_position = cur_down_position + val
	#if cur_top_position.x + val.x >= accessorie.min_x_vertical and cur_top_position.x + val.x <= accessorie.max_x_vertical and cur_top_position.y + val.y >= accessorie.min_y_vertical and cur_top_position.y + val.y <= accessorie.max_y_vertical:
		#cur_top_position.x = cur_top_position.x - val.x
		#cur_top_position.y = cur_top_position.y + val.y
	if cur_right_position.x + val.x >= accessorie.min_x_right and cur_right_position.x + val.x <= accessorie.max_x_right and  cur_right_position.y + val.y >= accessorie.min_y_right and cur_right_position.y + val.y <= accessorie.max_y_right:
		cur_right_position = cur_right_position + val
	if cur_left_position.x + val.x >= accessorie.min_x_left and cur_left_position.x + val.x <= accessorie.max_x_left and cur_left_position.y + val.y >= accessorie.min_y_left and cur_left_position.y + val.y <= accessorie.max_y_left:
		cur_left_position = cur_left_position + val

	var center_x = 7 
	var offset_from_center = cur_down_position.x - center_x
	cur_top_position.x = center_x - offset_from_center
	if cur_top_position.y + val.y >= accessorie.min_y_vertical and cur_top_position.y + val.y <= accessorie.max_y_vertical:
		cur_top_position.y = cur_top_position.y + val.y
	
	change_direction(Global.current_dir)
	
	change_direction(Global.current_dir)
			
func update_z_index():
	var central_point = base.global_position 
	if (central_point.x >= 31) and (central_point.x <= 33):
		if (z_left < 0):
			z_left = -1 * z_left
		if (z_right < 0):
			z_right = -1 * z_right
	elif (central_point.x < 31):
		if (z_left > 0):
			z_left = -1 * z_left
		if (z_right < 0):
			z_right = -1 * z_right
	elif (central_point.x > 33):
		if (z_left < 0):
			z_left = -1 * z_left
		if (z_right > 0):
			z_right = -1 * z_right
			
func flip_x(toggled_on):
	flip = toggled_on
	
	change_direction(Global.current_dir)
