extends MarginContainer

@onready var catallog = $"../Catalog"
@onready var button_container = $VScrollBar/VBoxContainer
@onready var position_controller = $"../PositionController"

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
	call_deferred("_update_order_and_positions")
	button_instance.element_deleted.connect(_on_accessory_deleted)
	button_instance.cur_position = button_instance.position

func _on_accessory_selected(element):
	position_controller.visible = true
	accessory_element_selected.emit(element)
	
func _on_accessory_deleted(button: AccessorieButton):
	if button in accessorie_buttons:
		if button.is_selected:
			position_controller.visible = false
		accessorie_buttons.erase(button)
		var timer = Timer.new()
		add_child(timer)
		timer.wait_time = 0.05  
		timer.one_shot = true
		timer.timeout.connect(func(): 
			_update_order_and_positions()
			timer.queue_free()  
		)
		timer.start()
		
		button.queue_free()


func swap_element(button):
	#print(button.position)
	var closest_button = get_closest_button(button)

	if closest_button != button:
		var button_index = button.get_index()
		var closest_button_index = closest_button.get_index()

		# Меняем местами в контейнере
		button_container.move_child(button, closest_button_index)
		button_container.move_child(closest_button, button_index)

		# Обновляем порядок в accessorie_buttons
		var temp = accessorie_buttons[button_index]
		accessorie_buttons[button_index] = accessorie_buttons[closest_button_index]
		accessorie_buttons[closest_button_index] = temp

		# Обновляем порядок z_index и позиции
		call_deferred("_update_order_and_positions")

	else:
		button.position = button.cur_position

func _update_order_and_positions():
	# Обновляем cur_position и z_index для всех кнопок в правильном порядке
	for i in range(accessorie_buttons.size()):
		var button = accessorie_buttons[i]
		button.cur_position = button.position
		
		match Global.current_dir:
			"down":
				button.accessorie_element.z_down = z_index + i + 1
				button.accessorie_element.z_top = -(z_index  + i + 1)
				button.accessorie_element.z_right = z_index + i + 1
				button.accessorie_element.z_left = z_index + i + 1
				
				button.accessorie_element.z_index = button.accessorie_element.z_down
			"top":
				button.accessorie_element.z_down = -(z_index  + i + 1)
				button.accessorie_element.z_top = z_index  + i + 1
				button.accessorie_element.z_right = z_index  + i + 1
				button.accessorie_element.z_left = z_index + i + 1
				
				button.accessorie_element.z_index = button.accessorie_element.z_top
			"right":
				button.accessorie_element.z_down = z_index   + i + 1
				button.accessorie_element.z_top = -(z_index  + i + 1)
				button.accessorie_element.z_right = z_index   + i + 1
				button.accessorie_element.z_left = z_index   + i + 1
				
				button.accessorie_element.z_index = button.accessorie_element.z_right
			"left":
				button.accessorie_element.z_down = z_index   + i + 1
				button.accessorie_element.z_top = -(z_index  + i + 1)
				button.accessorie_element.z_right = z_index   + i + 1
				button.accessorie_element.z_left = z_index  + i + 1
				
				button.accessorie_element.z_index = button.accessorie_element.z_left


#func _update_cur_positions(button, closest_button):
	## Обновляем cur_position для обеих кнопок
	#button.cur_position = button.position
	#closest_button.cur_position = closest_button.position

func get_closest_button(button):
	var closest_button = button  # Изначально ближайший — это сам переданный button
	var min_distance = abs(button.cur_position.y - button.position.y)

	# Проходим по всем детям в button_container
	for child in button_container.get_children():
		if child != button:  # Пропускаем сам button
			var distance = abs(child.position.y - button.position.y)
			#print(distance)
			if distance < min_distance:
				min_distance = distance
				closest_button = child

	return closest_button
	
	
func change_visible():
	visible = catallog.current_tab.is_in_group("Accessorie")
		
