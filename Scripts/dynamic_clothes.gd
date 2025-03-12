extends ColorRect

var is_symmetrical = false
var resource_dynamic_clothes: DynamicClothes
var color_picker_button
var cur_color: Color = Color(1, 1, 1)
var start_color: Color = Color(1, 1, 1)

var root
var character 
var catallog

func _ready() -> void:
	root = get_tree().root
	character = root.find_child("Character", true, false)
	catallog = root.find_child("Catalog", true, false)

func _connect_color_changed_signal():
	color_picker_button.color_changed.connect(_on_color_changed)
	
func _connect_color():
	color_picker_button._on_color_picker_color_changed(cur_color)
	color_picker_button.color_picker.color = cur_color
	set_start_color()
	
func set_start_color() -> void:
	_on_color_changed(start_color)
	color_picker_button.color_picker.color = start_color
	print (start_color)
	
func _on_color_changed(new_color: Color) -> void:
	cur_color = new_color
	self_modulate = cur_color
	color_picker_button.set_new_bg_color(new_color)
	
	if is_symmetrical:
		var target_node = catallog.current_tab.linked_symmetrical_element.catalog_items[0].item_class
		target_node = character.find_child(target_node, true, false)
		var cur_linked_element = target_node.find_child("DynamicClothes", true, false)
		cur_linked_element.self_modulate = cur_color
		cur_linked_element.color_picker_button.set_new_bg_color(new_color)
	




func change_direction() -> void:
		
	if Global.current_animation == "idle":	
		match Global.current_dir:
			"down":
				position = resource_dynamic_clothes.down_position
				size = resource_dynamic_clothes.down_size
				
			"right":
				position = resource_dynamic_clothes.right_position
				size = resource_dynamic_clothes.right_size
			"top":
				position = resource_dynamic_clothes.top_position
				size = resource_dynamic_clothes.top_size
			"left":
				position = resource_dynamic_clothes.left_position
				size = resource_dynamic_clothes.left_size
	
	elif Global.current_animation == "walk":	
		match Global.current_dir:
				"down":
					position = resource_dynamic_clothes.down_position_walk
					size = resource_dynamic_clothes.down_size
				"right":
					position = resource_dynamic_clothes.right_position_walk
					size = resource_dynamic_clothes.right_size
				"top":
					position = resource_dynamic_clothes.top_position_walk
					size = resource_dynamic_clothes.top_size
				"left":
					position = resource_dynamic_clothes.left_position_walk
					size = resource_dynamic_clothes.left_size
	pivot_offset = size / 2
