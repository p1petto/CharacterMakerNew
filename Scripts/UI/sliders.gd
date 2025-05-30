extends Container

@onready var catallog = $"../Catalog"
@onready var catallog_lists = $"../Catalog/CatalogContainer"
@onready var character = $"../../SubViewportContainer/SubViewport/Character"
@onready var character_texture = $"../CharacterShow"
var slider_scene = preload("res://Scenes/custom_h_slider.tscn")

func _ready() -> void:
	visible = true
	character.direction_change_sliders.connect(_on_direction_changed)
	
	catallog.tab_changed.connect(_on_tab_changed)
	
	for part in catallog_lists.get_children():
		part.change_sliders.connect(update_sliders)

	for part in character.get_children():
		if part.is_in_group("Dynamic") or part.is_in_group("ConditionallyDynamic"):
			_create_sliders_for_part(part)

	update_containers_visibility("down")
	size.y = 64 * Global.scaling
	position.y = character_texture.position.y 


func _on_tab_changed() -> void:
	visible = true
	update_containers_visibility(Global.current_dir)

func _on_direction_changed(dir):
	update_containers_visibility(dir)

func update_containers_visibility(direction: String) -> void:
	var current_part_name = catallog.current_tab.name
	for container in get_children():
		var is_correct_tab = container.name.begins_with(current_part_name)
		var is_correct_direction = false

		if container.name.ends_with("_vertical"):
			is_correct_direction = (direction == "down" or direction == "top")
		elif container.name.ends_with("_horizontal"):
			is_correct_direction = (direction == "right" or direction == "left")
		else:
			is_correct_direction = true

		container.visible = is_correct_tab and is_correct_direction
		pass

func _on_value_slider_changed(val, m, character_part_name, axis):
	var character_part = character.find_child(character_part_name, true, false)

	var cur_dir = Global.current_dir
	if character_part.is_in_group("Dynamic"):
		
		if cur_dir == "down":
			character_part.setup_polygon(cur_dir)
		elif cur_dir == "top":
			character_part.setup_polygon(cur_dir)
		elif cur_dir == "right":
			character_part.setup_polygon(cur_dir)
		elif cur_dir == "left":
			character_part.setup_polygon(cur_dir)
		
	elif character_part.is_in_group("ConditionallyDynamic"):
		
		character_part.change_thickness(val)
		if character_part.is_symmetrical:
			character_part.linked_symmetrical_element.change_thickness(val)
	elif character_part.is_in_group("Hair"):
		character_part.cur_state = str(val)
		character_part.change_direction()

func update_sliders(character_part_name):
	var character_part = character.find_child(character_part_name, true, false)

	for child in get_children():
		if child.name.begins_with(character_part_name):
			child.queue_free()

	await get_tree().process_frame  

	_create_sliders_for_part(character_part)

	update_containers_visibility("down")

			
func _create_sliders_for_part(part):
	
	if part.is_in_group("Dynamic"):
		var part_container_vertical = load("res://Scenes/slider_window.tscn").instantiate()
		var part_container_horizontal = load("res://Scenes/slider_window.tscn").instantiate()
		part_container_vertical.name = part.name + "_vertical"
		part_container_horizontal.name = part.name + "_horizontal"
		
		if part.dynamic_part.vertical_markers:
			var polygon_2d = part.get_node("Polygon2D")
			var first_marker = part.dynamic_part.vertical_markers[0]
			#part_container_vertical.position.y = polygon_2d.polygon[first_marker].y * Global.scaling + part.position.y 
			part_container_vertical.position.y = character_texture.position.y + polygon_2d.polygon[first_marker].y * Global.scaling - part.position.y * Global.scaling/2 + 16
			add_child(part_container_vertical)
			
			var vertical_container = part_container_vertical.get_node("CenterContainer/VBoxContainer")
			for marker in part.dynamic_part.vertical_markers:
				var slider = slider_scene.instantiate()
				slider.character_part = part.name
				slider.linked_marker = marker
				slider.axis = "vertical"
				vertical_container.add_child(slider)
				slider.slider_value_changed.connect(_on_value_slider_changed)
				part_container_vertical.size.y += 18
		
		if part.dynamic_part.horizontal_markers:
			var polygon_2d = part.get_node("Polygon2D")
			var first_marker = part.dynamic_part.horizontal_markers[0]
			part_container_horizontal.position.y = character_texture.position.y + polygon_2d.polygon[first_marker].y * Global.scaling - part.position.y * Global.scaling/2  + 16
			part_container_horizontal.visible = false
			add_child(part_container_horizontal)
			
			var horizontal_container = part_container_horizontal.get_node("CenterContainer/VBoxContainer")
			for marker in part.dynamic_part.horizontal_markers:
				var slider = slider_scene.instantiate()
				slider.character_part = part.name
				slider.linked_marker = marker
				slider.axis = "horizontal"
				horizontal_container.add_child(slider)
				slider.slider_value_changed.connect(_on_value_slider_changed)
				part_container_horizontal.size.y += 18
	
	if part.is_in_group("ConditionallyDynamic"):
		var part_container = load("res://Scenes/slider_window.tscn").instantiate()
		part_container.name = part.name
		part_container.position.y = part.marker_y_pos * Global.scaling - 20
		#part_container.position.y = part.marker_y_pos * Global.scaling - part.position.y * Global.scaling/2  + 16
		add_child(part_container)
		
		var container = part_container.get_node("CenterContainer/VBoxContainer")
		var slider = slider_scene.instantiate()
		slider.character_part = part.name
		slider.min_value = 1
		slider.value = 1
		container.add_child(slider)
		slider.slider_value_changed.connect(_on_value_slider_changed)
	
	if part.is_in_group("Hair"):
		
		
		if part.hair_resource.quantity > 1:
			var part_container = load("res://Scenes/slider_window.tscn").instantiate()
			part_container.name = part.name
			part_container.position.y = character.head.position.y * Global.scaling
			add_child(part_container)
			
			var container = part_container.get_node("CenterContainer/VBoxContainer")
			var slider = slider_scene.instantiate()
			slider.character_part = part.name
			slider.min_value = 1
			slider.max_value = part.hair_resource.quantity
			slider.value = 1
			container.add_child(slider)
			slider.slider_value_changed.connect(_on_value_slider_changed)
