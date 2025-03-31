extends ColorRect

var is_symmetrical = false
var resource_dynamic_clothes: DynamicClothes
var color_picker_button
var cur_color: Color = Color(1, 1, 1)
var start_color: Color = Color(1, 1, 1)
var root
var character 
var catallog
var catallog_container
var parent_part  # Reference to the parent ConditionallyDynamicCharacterPart

func _ready() -> void:
	root = get_tree().root
	character = root.find_child("Character", true, false)
	catallog = root.find_child("Catalog", true, false)
	parent_part = get_parent().get_parent()  # Get reference to parent ConditionallyDynamicCharacterPart
	catallog_container = catallog.get_node("CatalogContainer")
	
	# Проверяем наличие и инициализируем материал
	if !material && resource_dynamic_clothes:
		var shader = load("res://Scripts/Shaders/CD_color_rect_clothes.gdshader")  # Замените на фактический путь
		material = ShaderMaterial.new()
		material.shader = shader
		material.set_shader_parameter("is_flooded_inside", resource_dynamic_clothes.is_flooded_inside)
		material.set_shader_parameter("radius", 0.5)
		material.set_shader_parameter("border_width", 0.0)
		material.set_shader_parameter("border_color", Color(0, 0, 0, 1))
		
func _connect_color_changed_signal():
	color_picker_button.color_changed.connect(_on_color_changed)
	
func _connect_color():
	color_picker_button._on_color_picker_color_changed(cur_color)
	color_picker_button.color_picker.color = cur_color
	set_start_color()
	
func set_start_color() -> void:
	_on_color_changed(start_color)
	color_picker_button.color_picker.color = start_color
	
func _on_color_changed(new_color: Color) -> void:
	cur_color = new_color
	self_modulate = cur_color
	color_picker_button.set_new_bg_color(new_color)
	
	
	if is_symmetrical:
		print("is_symmetrical")
		var linked_parrent_tab 
		var parrent = get_node("../../")
		for tab in catallog_container.get_children():
			if tab.name == parrent.name:
				linked_parrent_tab = tab.linked_symmetrical_element
				break
		var target_node = character.find_child(linked_parrent_tab.name, true, false)
		var cur_linked_element
		if resource_dynamic_clothes.is_flooded_inside:
			print("!!!!!!")
			cur_linked_element = target_node.find_child("DynamicClothes", true, false)
		else:
			print("ELSE")
			cur_linked_element = target_node.find_child("TipWear", true, false)
		cur_linked_element.self_modulate = cur_color
		cur_linked_element.color_picker_button.set_new_bg_color(new_color)
	
func change_direction() -> void:
	# Use the part-specific ID to determine positions
	var part_id = parent_part.name  # or any other identifier for the specific part
	
	# Проверяем наличие материала и создаем его при необходимости
	if !material:
		var shader = load("res://Scripts/Shaders/CD_color_rect_clothes.gdshader")  # Замените на фактический путь
		material = ShaderMaterial.new()
		material.shader = shader
	
	# Обновляем параметр шейдера в любом случае
	if resource_dynamic_clothes:
		material.set_shader_parameter("is_flooded_inside", resource_dynamic_clothes.is_flooded_inside)
	
	if Global.current_animation == "idle":
		match Global.current_dir:
			"down":
				position = get_position_for_part(part_id, "down", "idle")
				size = get_size_for_part(part_id, "down", "idle")
			"right":
				position = get_position_for_part(part_id, "right", "idle")
				size = get_size_for_part(part_id, "right", "idle")
			"top":
				position = get_position_for_part(part_id, "top", "idle")
				size = get_size_for_part(part_id, "top", "idle")
			"left":
				position = get_position_for_part(part_id, "left", "idle")
				size = get_size_for_part(part_id, "left", "idle")
	elif Global.current_animation == "walk":
		match Global.current_dir:
			"down":
				position = get_position_for_part(part_id, "down", "walk")
				size = get_size_for_part(part_id, "down", "walk")
			"right":
				position = get_position_for_part(part_id, "right", "walk")
				size = get_size_for_part(part_id, "right", "walk")
			"top":
				position = get_position_for_part(part_id, "top", "walk")
				size = get_size_for_part(part_id, "top", "walk")
			"left":
				position = get_position_for_part(part_id, "left", "walk")
				size = get_size_for_part(part_id, "left", "walk")
	
	pivot_offset = size / 2

# Helper functions to get position and size based on part ID
func get_position_for_part(part_id: String, direction: String, animation: String) -> Vector2:
	# First try to get part-specific position
	if resource_dynamic_clothes.has_meta("position_" + part_id + "_" + direction + "_" + animation):
		return resource_dynamic_clothes.get_meta("position_" + part_id + "_" + direction + "_" + animation)
	
	# Fall back to generic positions if part-specific not found
	if animation == "idle":
		match direction:
			"down": return resource_dynamic_clothes.down_position
			"right": return resource_dynamic_clothes.right_position
			"top": return resource_dynamic_clothes.top_position
			"left": return resource_dynamic_clothes.left_position
	else:  # walk
		match direction:
			"down": return resource_dynamic_clothes.down_position_walk
			"right": return resource_dynamic_clothes.right_position_walk
			"top": return resource_dynamic_clothes.top_position_walk
			"left": return resource_dynamic_clothes.left_position_walk
	
	return Vector2.ZERO  # Default fallback

func get_size_for_part(part_id: String, direction: String, animation: String) -> Vector2:
	# Similar approach for sizes
	if resource_dynamic_clothes.has_meta("size_" + part_id + "_" + direction + "_" + animation):
		return resource_dynamic_clothes.get_meta("size_" + part_id + "_" + direction + "_" + animation)
	
	# Fall back to generic sizes
	match direction:
		"down": return resource_dynamic_clothes.down_size
		"right": return resource_dynamic_clothes.right_size
		"top": return resource_dynamic_clothes.top_size
		"left": return resource_dynamic_clothes.left_size
	
	return Vector2.ZERO  # Default fallback
