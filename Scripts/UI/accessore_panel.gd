extends MarginContainer

@onready var catallog = $"../Catalog"
@onready var button_container = $VScrollBar/VBoxContainer
@onready var position_controller = $"../PositionController"
@onready var color_scheme_controller = $"../Catalog/CatalogContainer/ColorSettings/CenterContainer/ColorSchemeController"

@export var accessory_buttons: Array[AccessorieButton]
@export var start_z_index = 1000

@export_enum("Accessory", "Hair")
var panel_type: String 

signal accessory_element_selected

var active_button: AccessorieButton


func add_accessorie_button(accessory, element):
	var button_scene = preload("res://Scenes/UI/AccessoreButton.tscn")
	var button_instance = button_scene.instantiate()
	button_instance.accessory = accessory
	button_instance.accessory_element = element
	button_container.add_child(button_instance)
	button_instance.position_changed.connect(swap_element)
	accessory_buttons.append(button_instance)
	element.accessory_button = button_instance
	button_instance.accessory_selected.connect(_on_accessory_selected)
	button_instance.element_deleted.connect(_on_accessory_deleted)
	button_instance.changed_active_status.connect(_on_active_changed)
	
	call_deferred("_store_button_position", button_instance)
	
	element.color_picker_button = button_instance.color_picker_button
	if accessory.has_line:
		element.color_picker_button_line = button_instance.color_picker_button_line
		button_instance.color_picker_button_line.visible = true
	_setup_z_index_for_new_element(button_instance)

	if panel_type == "Accessory":
		color_scheme_controller.accessory_buttons.append(button_instance.color_picker_button)
	elif panel_type == "Hair":
		color_scheme_controller.hair_buttons.append(button_instance.color_picker_button)
	
	
	
	button_instance.is_active = true
	_on_active_changed(button_instance)
	position_controller.visible = true
	button_instance.update_slot_texture()

func _store_button_position(button):
	button.cur_position = button.position

func _setup_z_index_for_new_element(button):
	var z_index = start_z_index  
	var i = accessory_buttons.size() - 1  
	button.accessory_element.z_right = z_index + i + 1
	button.accessory_element.z_left = z_index + i + 1

	match Global.current_dir:
		"down":
			button.accessory_element.z_down = z_index + i + 1
			button.accessory_element.z_top = -(z_index + i + 1)
			button.accessory_element.z_index = button.accessory_element.z_down
		"top":
			button.accessory_element.z_down = -(z_index + i + 1)
			button.accessory_element.z_top = z_index + i + 1
			button.accessory_element.z_index = button.accessory_element.z_top
		"right":
			button.accessory_element.z_down = z_index + i + 1
			button.accessory_element.z_top = -(z_index + i + 1)
			button.accessory_element.z_index = button.accessory_element.z_right
		"left":
			button.accessory_element.z_down = z_index + i + 1
			button.accessory_element.z_top = -(z_index + i + 1)
			button.accessory_element.z_index = button.accessory_element.z_left

func _on_accessory_selected(accessory_button, element):
	if active_button != null:
		active_button.is_active = false
		active_button.update_slot_texture()
	active_button = accessory_button
	active_button.is_active = true
	active_button.update_slot_texture()
	
	hide_color_picker()
	position_controller.visible = true
	accessory_element_selected.emit(element)
	
	call_deferred("_preserve_button_positions")
	
func _preserve_button_positions():
	for button in accessory_buttons:
		if button.cur_position != Vector2.ZERO:
			button.position = button.cur_position
	
func _on_accessory_deleted(button: AccessorieButton):
	hide_color_picker()
	if button in accessory_buttons:
		if panel_type == "Accessory":
			if button.color_picker_button in color_scheme_controller.accessory_buttons:
				color_scheme_controller.accessory_buttons.erase(button.color_picker_button)
		elif panel_type == "Hair":
			if button.color_picker_button in color_scheme_controller.accessory_buttons:
				color_scheme_controller.hair_buttons.erase(button.color_picker_button)
		
		
		position_controller.visible = false
		accessory_buttons.erase(button)
		var timer = Timer.new()
		add_child(timer)
		timer.wait_time = 0.05  
		timer.one_shot = true
		timer.timeout.connect(func(): 
			_update_swapped_positions() 
			timer.queue_free()  
		)
		timer.start()
		
		button.queue_free()


func _swap_z_indices(button1, button2):
	var temp_z_down = button1.accessory_element.z_down
	var temp_z_top = button1.accessory_element.z_top
	var temp_z_right = button1.accessory_element.z_right
	var temp_z_left = button1.accessory_element.z_left
	
	button1.accessory_element.z_down = button2.accessory_element.z_down
	button1.accessory_element.z_top = button2.accessory_element.z_top
	button1.accessory_element.z_right = button2.accessory_element.z_right
	button1.accessory_element.z_left = button2.accessory_element.z_left
	
	button2.accessory_element.z_down = temp_z_down
	button2.accessory_element.z_top = temp_z_top
	button2.accessory_element.z_right = temp_z_right
	button2.accessory_element.z_left = temp_z_left
	
	_update_current_z_indices()

func _update_current_z_indices():
	for button in accessory_buttons:
		match Global.current_dir:
			"down":
				button.accessory_element.z_index = button.accessory_element.z_down
			"top":
				button.accessory_element.z_index = button.accessory_element.z_top
			"right":
				button.accessory_element.z_index = button.accessory_element.z_right
			"left":
				button.accessory_element.z_index = button.accessory_element.z_left

func _update_swapped_positions():
	for button in accessory_buttons:
		button.cur_position = button.position

func get_closest_button(button):
	var closest_button = button
	var min_distance = abs(button.cur_position.y - button.position.y)

	for child in button_container.get_children():
		if child != button:
			var distance = abs(child.position.y - button.position.y)
			if distance < min_distance:
				min_distance = distance
				closest_button = child

	return closest_button
	
	
func hide_color_picker():
	for button in accessory_buttons:
		button.color_picker_button._on_toggled(false)
		button.color_picker_button_line._on_toggled(false)
		button.color_picker_button.button_pressed = false
		

func _on_active_changed(accessory_button):
	active_button = accessory_button
	position_controller._on_aacessory_element_selected(active_button.accessory_element)
	for button in accessory_buttons:
		if button != accessory_button:
			if button.is_active:
				button.is_active = false
				button.update_slot_texture()
				if button.color_picker_button.color_picker.visible:
					button.color_picker_button.color_picker.visible = false
				if button.color_picker_button_line.color_picker.visible:
					button.color_picker_button_line.color_picker.visible = false

func swap_element(button):
	hide_color_picker()
	var target_position = get_target_position(button)
	var button_original_index = button.get_index()

	
	if target_position != button_original_index:
		var button_to_move = accessory_buttons[button_original_index]
		accessory_buttons.remove_at(button_original_index)
		
		if target_position > button_original_index:
			target_position -= 1
		
		accessory_buttons.insert(target_position, button_to_move)
		
		button_container.move_child(button, target_position)
		
		# Вызываем обновление позиций и z-индексов
		call_deferred("_update_swapped_positions")
		call_deferred("_update_z_indices_after_reorder")
	else:
		button.position = button.cur_position

func get_target_position(button):
	var button_y = button.position.y
	var insert_position = 0
	
	for i in range(button_container.get_child_count()):
		var child = button_container.get_child(i)
		if child != button:
			if button_y > child.position.y + (child.size.y / 2):
				insert_position = i + 1
	
	return insert_position

func _update_z_indices_after_reorder():
	var z_index_base = start_z_index
	
	for i in range(accessory_buttons.size()):
		var button = accessory_buttons[i]
		var z_value = z_index_base + i + 1
		
		button.accessory_element.z_right = z_value
		button.accessory_element.z_left = z_value
		button.accessory_element.z_down = z_value
		button.accessory_element.z_top = -z_value
		
		match Global.current_dir:
			"down":
				button.accessory_element.z_index = button.accessory_element.z_down
			"top":
				button.accessory_element.z_index = button.accessory_element.z_top
			"right":
				button.accessory_element.z_index = button.accessory_element.z_right
			"left":
				button.accessory_element.z_index = button.accessory_element.z_left
			
