extends AnimatedSprite2D

class_name Hair

@export var hair_resource: HairResource

@onready var line = $Line

var color_picker_button
var color_picker_button_line
var cur_color
var initial_color
var initial_color_line
var cur_state = "1"

func _ready() -> void:
	call_deferred("_connect_color_changed_signal")
	initialize()

func initialize():
	sprite_frames = hair_resource.sprite_frames
	if hair_resource.sprite_frames_line:
		line.sprite_frames = hair_resource.sprite_frames_line
	cur_state = "1"
	
	call_deferred("_connect_color")
	change_direction()
	
func change_direction():
	if hair_resource.quantity > 1:
		animation = Global.current_dir + "_" + cur_state
		if hair_resource.sprite_frames_line:
			line.animation = Global.current_dir + "_" + cur_state
	else:
		animation = Global.current_dir
		if hair_resource.sprite_frames_line:
			line.animation = Global.current_dir 
			
	match Global.current_dir:
		"down":
			position = hair_resource.pos_down
			z_index = hair_resource.z_down
		"right":
			position = hair_resource.pos_right
			z_index = hair_resource.z_right
		"top":
			position = hair_resource.pos_top
			z_index = hair_resource.z_top
		"left":
			position = hair_resource.pos_left
			z_index = hair_resource.z_left
			

			
func _connect_color_changed_signal():
	color_picker_button.color_changed.connect(_on_color_changed)
	if hair_resource.has_line:
		color_picker_button_line.color_changed.connect(_on_line_color_changed)
	
func _connect_color():
	cur_color = hair_resource.initial_color
	color_picker_button._on_color_picker_color_changed(cur_color)
	color_picker_button.color_picker.color = cur_color
	initial_color = cur_color
	initial_color_line = hair_resource.initial_color_line
	set_start_color()
	
func set_start_color() -> void:
	cur_color = initial_color
	_on_color_changed(initial_color)
	_on_line_color_changed(initial_color_line)

func _on_color_changed(new_color: Color) -> void:
	cur_color = new_color
	self_modulate = cur_color
	
func _on_line_color_changed(new_color: Color) -> void:
	line.self_modulate = new_color
	if hair_resource.has_line:
		color_picker_button_line.set_new_bg_color(new_color)
		
