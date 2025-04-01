extends Node2D

@export var resource_clothing: StaticClothing


@onready var base = $Base
@onready var line = $Line

var color_picker_button
var color_picker_button_line
var cur_color: Color
var initial_color: Color = Color(1,1,1)
var initial_color_line: Color

var anchor_node


func initialize():
	if resource_clothing.sprite_frames and resource_clothing.sprite_frames_line:
		base.sprite_frames = resource_clothing.sprite_frames
		line.sprite_frames = resource_clothing.sprite_frames_line
	position = resource_clothing.pos
	change_direction()
	call_deferred("_connect_color_changed_signal")
	call_deferred("_connect_color")
		
func change_direction():
	base.animation = Global.current_dir
	line.animation = Global.current_dir
	match Global.current_dir:
		"down":
			z_index = resource_clothing.z_down
		"right":
			z_index = resource_clothing.z_right
		"top":
			z_index = resource_clothing.z_top
		"left":
			z_index = resource_clothing.z_left
			
			
func _connect_color_changed_signal():
	color_picker_button.color_changed.connect(_on_color_changed)
	color_picker_button_line.color_changed.connect(_on_line_color_changed)
	
func _connect_color():
	cur_color = resource_clothing.initial_color
	color_picker_button._on_color_picker_color_changed(cur_color)
	color_picker_button.color_picker.color = cur_color
	initial_color = cur_color
	initial_color_line = resource_clothing.initial_color_line
	set_start_color()
	
func set_start_color() -> void:
	cur_color = initial_color
	_on_color_changed(initial_color)
	_on_line_color_changed(initial_color_line)

func _on_color_changed(new_color: Color) -> void:
	cur_color = new_color
	base.self_modulate = cur_color
		
func _on_line_color_changed(new_color: Color) -> void:
	line.self_modulate = new_color
	color_picker_button_line.set_new_bg_color(new_color)
	
