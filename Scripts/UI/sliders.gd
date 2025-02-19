extends Container

@onready var catallog = $"../Catalog"
@onready var character = $"../../SubViewportContainer/SubViewport/Character"
var slider_scene = preload("res://Scenes/custom_h_slider.tscn")

func _ready() -> void:
	character.change_sliders.connect(_on_direction_changed)
	
	for part in catallog.get_children():
		part.change_sliders.connect(update_sliders)

	for part in character.get_children():
		if part.is_in_group("Dynamic") or part.is_in_group("ConditionallyDynamic"):
			_create_sliders_for_part(part)

	update_containers_visibility("down")

func _process(delta: float) -> void:
	pass

func _on_catalog_tab_changed(tab: int) -> void:
	var direction = "down"
	if character:
		direction = character.cur_dir
	update_containers_visibility(direction)

func _on_direction_changed(dir):
	update_containers_visibility(dir)

func update_containers_visibility(direction: String) -> void:
	var current_part_name = catallog.get_child(catallog.current_tab).name
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

func _on_value_slider_changed(val, m, character_part_name, axis):
	var character_part = character.get_node(character_part_name)
	var cur_dir = character.cur_dir
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
		pass
		


func update_sliders(character_part_name):
	var character_part = character.get_node(character_part_name)

	# Удаление старых контейнеров
	for child in get_children():
		if child.name.begins_with(character_part_name):
			child.queue_free()

	await get_tree().process_frame  # Ждём 1 кадр, чтобы узлы полностью удалились

	# Создание новых слайдеров
	_create_sliders_for_part(character_part)

	update_containers_visibility("down")

func _create_sliders_for_part(part):
	if part.is_in_group("Dynamic"):
		var part_container_vertical = VBoxContainer.new()
		var part_container_horizontal = VBoxContainer.new()

		part_container_vertical.name = part.name + "_vertical"
		part_container_horizontal.name = part.name + "_horizontal"

		if part.dynamic_part.vertical_markers:
			var polygon_2d = part.get_node("Polygon2D")
			var first_marker = part.dynamic_part.vertical_markers[0]
			part_container_vertical.position.y = polygon_2d.polygon[first_marker].y * 5 + part.position.y * 5

			add_child(part_container_vertical)

			for marker in part.dynamic_part.vertical_markers:
				var slider = slider_scene.instantiate()
				slider.character_part = part.name
				slider.linked_marker = marker
				slider.axis = "vertical"
				part_container_vertical.add_child(slider)
				slider.slider_value_changed.connect(_on_value_slider_changed)

		if part.dynamic_part.horizontal_markers:
			var polygon_2d = part.get_node("Polygon2D")
			var first_marker = part.dynamic_part.horizontal_markers[0]
			part_container_horizontal.position.y = polygon_2d.polygon[first_marker].y * 5 + part.position.y * 5
			part_container_horizontal.visible = false
			add_child(part_container_horizontal)

			for marker in part.dynamic_part.horizontal_markers:
				var slider = slider_scene.instantiate()
				slider.character_part = part.name
				slider.linked_marker = marker
				slider.axis = "horizontal"
				part_container_horizontal.add_child(slider)
				slider.slider_value_changed.connect(_on_value_slider_changed)

	if part.is_in_group("ConditionallyDynamic"):
		var part_container = VBoxContainer.new()
		part_container.name = part.name
		part_container.position.y = part.marker_y_pos * 5

		add_child(part_container)
		var slider = slider_scene.instantiate()
		slider.character_part = part.name
		part_container.add_child(slider)
		slider.slider_value_changed.connect(_on_value_slider_changed)
