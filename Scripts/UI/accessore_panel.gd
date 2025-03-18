extends MarginContainer

@onready var catallog = $"../Catalog"
@onready var button_container = $VScrollBar/VBoxContainer
@onready var position_controller = $"../PositionController"
@onready var color_scheme_controller = $"../Catalog/CatalogContainer/ColorSettings/CenterContainer/ColorSchemeController"

#@export var accessories: Array[Accessorie]
@export var accessorie_buttons: Array[AccessorieButton]

signal accessory_element_selected

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	catallog.tab_changed.connect(change_visible)

func add_accessorie_button(accessorie, element):
	var button_scene = preload("res://Scenes/UI/AccessoreButton.tscn")
	var button_instance = button_scene.instantiate()
	button_instance.accessorie = accessorie
	button_instance.accessorie_element = element
	button_container.add_child(button_instance)
	button_instance.position_changed.connect(swap_element)
	accessorie_buttons.append(button_instance)
	element.accessorie_button = button_instance
	button_instance.accessory_selected.connect(_on_accessory_selected)
	button_instance.element_deleted.connect(_on_accessory_deleted)
	
	# Store the initial position after the button is added to the container
	call_deferred("_store_button_position", button_instance)
	
	element.color_picker_button = button_instance.color_picker_button
	
	# Only update the z-index for the newly added element
	_setup_z_index_for_new_element(button_instance)
	
	color_scheme_controller.accessory_buttons.append(button_instance)

func _store_button_position(button):
	# Store the button's position after it has been properly positioned in the container
	button.cur_position = button.position

func _setup_z_index_for_new_element(button):
	# Set up the initial z-index values for this new button only
	var z_index = 1000  # Base z-index value
	var i = accessorie_buttons.size() - 1  # Index of the new button
	
	match Global.current_dir:
		"down":
			button.accessorie_element.z_down = z_index + i + 1
			button.accessorie_element.z_top = -(z_index + i + 1)
			button.accessorie_element.z_right = z_index + i + 1
			button.accessorie_element.z_left = z_index + i + 1
			
			button.accessorie_element.z_index = button.accessorie_element.z_down
		"top":
			button.accessorie_element.z_down = -(z_index + i + 1)
			button.accessorie_element.z_top = z_index + i + 1
			button.accessorie_element.z_right = z_index + i + 1
			button.accessorie_element.z_left = z_index + i + 1
			
			button.accessorie_element.z_index = button.accessorie_element.z_top
		"right":
			button.accessorie_element.z_down = z_index + i + 1
			button.accessorie_element.z_top = -(z_index + i + 1)
			button.accessorie_element.z_right = z_index + i + 1
			button.accessorie_element.z_left = z_index + i + 1
			
			button.accessorie_element.z_index = button.accessorie_element.z_right
		"left":
			button.accessorie_element.z_down = z_index + i + 1
			button.accessorie_element.z_top = -(z_index + i + 1)
			button.accessorie_element.z_right = z_index + i + 1
			button.accessorie_element.z_left = z_index + i + 1
			
			button.accessorie_element.z_index = button.accessorie_element.z_left

func _on_accessory_selected(element):
	hide_color_picker()
	position_controller.visible = true
	accessory_element_selected.emit(element)
	
	# Make sure positions are preserved after selection
	call_deferred("_preserve_button_positions")
	
func _preserve_button_positions():
	# Ensure all buttons maintain their positions
	for button in accessorie_buttons:
		if button.cur_position != Vector2.ZERO:
			button.position = button.cur_position
	
func _on_accessory_deleted(button: AccessorieButton):
	hide_color_picker()
	if button in accessorie_buttons:
		if button.is_selected:
			position_controller.visible = false
		accessorie_buttons.erase(button)
		var timer = Timer.new()
		add_child(timer)
		timer.wait_time = 0.05  
		timer.one_shot = true
		timer.timeout.connect(func(): 
			_update_swapped_positions()  # Only update positions, not z-indices
			timer.queue_free()  
		)
		timer.start()
		
		button.queue_free()

func swap_element(button):
	hide_color_picker()
	var closest_button = get_closest_button(button)

	if closest_button != button:
		var button_index = button.get_index()
		var closest_button_index = closest_button.get_index()

		# Swap in container
		button_container.move_child(button, closest_button_index)
		button_container.move_child(closest_button, button_index)

		# Update order in accessorie_buttons
		var temp = accessorie_buttons[button_index]
		accessorie_buttons[button_index] = accessorie_buttons[closest_button_index]
		accessorie_buttons[closest_button_index] = temp

		# Only update positions after swap, not z-indices
		call_deferred("_update_swapped_positions")
		
		# Swap z-indices between the two swapped buttons
		_swap_z_indices(button, closest_button)
	else:
		button.position = button.cur_position

func _swap_z_indices(button1, button2):
	# Swap all z-index values between the two elements
	var temp_z_down = button1.accessorie_element.z_down
	var temp_z_top = button1.accessorie_element.z_top
	var temp_z_right = button1.accessorie_element.z_right
	var temp_z_left = button1.accessorie_element.z_left
	
	button1.accessorie_element.z_down = button2.accessorie_element.z_down
	button1.accessorie_element.z_top = button2.accessorie_element.z_top
	button1.accessorie_element.z_right = button2.accessorie_element.z_right
	button1.accessorie_element.z_left = button2.accessorie_element.z_left
	
	button2.accessorie_element.z_down = temp_z_down
	button2.accessorie_element.z_top = temp_z_top
	button2.accessorie_element.z_right = temp_z_right
	button2.accessorie_element.z_left = temp_z_left
	
	# Update current z_index based on current direction
	_update_current_z_indices()

func _update_current_z_indices():
	# Only update the current z_index based on the current direction, not recalculating all z values
	for button in accessorie_buttons:
		match Global.current_dir:
			"down":
				button.accessorie_element.z_index = button.accessorie_element.z_down
			"top":
				button.accessorie_element.z_index = button.accessorie_element.z_top
			"right":
				button.accessorie_element.z_index = button.accessorie_element.z_right
			"left":
				button.accessorie_element.z_index = button.accessorie_element.z_left

func _update_swapped_positions():
	# Only update the cur_position for all buttons after a swap
	for button in accessorie_buttons:
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
	
func change_visible():
	visible = catallog.current_tab.is_in_group("Accessorie")
	
func hide_color_picker():
	for button in accessorie_buttons:
		button.color_picker_button._on_toggled(false)
		button.color_picker_button.button_pressed = false
