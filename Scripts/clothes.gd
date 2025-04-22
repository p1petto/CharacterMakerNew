extends TextureRect
var resource_clothes: Clothes
var color_picker_button
var cur_color: Color = Color(1, 1, 1)
var start_color: Color = Color(1, 1, 1)



func initialize():
	texture = resource_clothes.clothes_texture
	change_dir()
	set_start_color()

func change_dir():
	
	if resource_clothes:
		match Global.current_dir:
			"down":
				if Global.current_animation == "idle":
					position = resource_clothes.down_idle_position
				elif Global.current_animation == "walk":
					position = resource_clothes.down_walk_position
			"right":
				if Global.current_animation == "idle":
					position = resource_clothes.right_idle_position
				elif Global.current_animation == "walk":
					position = resource_clothes.right_walk_position
			"top":
				if Global.current_animation == "idle":
					position = resource_clothes.top_idle_position
				elif Global.current_animation == "walk":
					position = resource_clothes.top_walk_position
			"left":
				if Global.current_animation == "idle":
					position = resource_clothes.left_idle_position
				elif Global.current_animation == "walk":
					position = resource_clothes.left_walk_position
		
		
func _connect_color_changed_signal():
	color_picker_button.color_changed.connect(_on_color_changed)
	
func _connect_color():
	color_picker_button._on_color_picker_color_changed(cur_color)
	color_picker_button.color_picker.set_color_from_code(cur_color)
	set_start_color()
	
func set_start_color() -> void:
	_on_color_changed(start_color)
	color_picker_button.color_picker.set_color_from_code(start_color)

	
func _on_color_changed(new_color: Color) -> void:
	cur_color = new_color
	self_modulate = cur_color
	color_picker_button.set_new_bg_color(new_color)
	
