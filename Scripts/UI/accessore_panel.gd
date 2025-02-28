extends MarginContainer

@onready var catallog = $"../Catalog"
@onready var button_container = $VScrollBar/VBoxContainer

@export var accessories: Array[Accessorie]
@export var accessorie_buttons: Array[AccessorieButton]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#visible = false
	#catallog.tab_changed.connect(_on_tab_changed)
	#$"../Catalog/CatalogContainer/Accessories".added_accessorie.connect(_on_list_accessorie_changed)
	#
	if accessories:
		for accessorie in accessories:
			add_accessorie_button(accessorie)
		
	
func _on_tab_changed():
	visible = catallog.current_tab.is_in_group("Accessorie")

func add_accessorie_button(accessorie):
	var button_scene = preload("res://Scenes/UI/AccessoreButton.tscn")
	var button_instance = button_scene.instantiate()
	button_instance.accessorie = accessorie
	button_container.add_child(button_instance)
	button_instance.position_changed.connect(swap_element)
	accessorie_buttons.append(button_instance)

func _on_list_accessorie_changed():
	add_accessorie_button(accessories[len(accessories)-1])

func swap_element(button):
	print(button.position)
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

func get_closest_button(button):
	var closest_button = button  # Изначально ближайший — это сам переданный button
	var min_distance = abs(button.cur_position.y - button.position.y)
	print("min distance ", min_distance)

	# Проходим по всем детям в button_container
	for child in button_container.get_children():
		if child != button:  # Пропускаем сам button
			var distance = abs(child.position.y - button.position.y)
			print(distance)
			if distance < min_distance:
				min_distance = distance
				closest_button = child

	print("Closest button Y position:", closest_button.position.y)
	return closest_button
