extends MarginContainer

@onready var catallog_container = $CatalogContainer
@onready var button_container = $ButtonsScrollContainer/HBoxContainer
@onready var button_scroll_container = $ButtonsScrollContainer
@onready var character = $"../../SubViewportContainer/SubViewport/Character"
var color_picker_button
@onready var color_picker_button_container =  $"../ColorPickerButtonContainer"

@export var current_tab: CustomTab

signal tab_changed

func _ready() -> void:
	# Отложим назначение color_picker_button
	call_deferred("_initialize_color_picker_button")

	for catalog_item in catallog_container.get_children():
		var new_slot = load("res://Scenes/UI/catalog_type_slot.tscn").instantiate()
		new_slot.tab_name = catalog_item.name
		button_container.add_child(new_slot)
		
		if catalog_item.linked_symmetrical_element:
			var new_check_button = load("res://Scenes/UI/custom_check_button.tscn").instantiate()
			catalog_item.add_child(new_check_button)
			catalog_item.move_child(new_check_button, 0)
			new_check_button.button_toggled.connect(_on_check_button_toggled)
			
		#catalog_item.update_color.connect(_on_color_updated)
		
	for catalog_class in button_container.get_children():
		catalog_class.catalog_tab_changed.connect(_on_catalog_tab_changed)

func _initialize_color_picker_button() -> void:
	color_picker_button = color_picker_button_container.get_node(NodePath(current_tab.name))  # Преобразуем строку в NodePath
	color_picker_button.visible = true
	
#func _on_color_updated(color):
	#
	

func _on_catalog_tab_changed(tab_name):
	current_tab.visible = false
	current_tab = find_tab(tab_name)
	current_tab.visible = true
	tab_changed.emit()
	color_picker_button.button_pressed = false
	color_picker_button.visible = false
	if !current_tab.is_in_group("Accessorie"):
		_initialize_color_picker_button()
		color_picker_button.visible = true

func find_tab(tab_name):
	return catallog_container.get_node(tab_name)

func _on_check_button_toggled(toggled_on):
	var linked_tab = current_tab.linked_symmetrical_element
	if linked_tab:
		var linked_check_button = linked_tab.get_node("VBoxContainer/CustomCheckButton")
		if linked_check_button and linked_check_button.get_node("CheckButton").button_pressed != toggled_on:
			linked_check_button.get_node("CheckButton").set_pressed_no_signal(toggled_on)
		
		# Поиск ноды внутри character или его дочерних элементов
		var current_node = character.find_child(str(current_tab.name), true, false)
		var linked_node = character.find_child(str(linked_tab.name), true, false)

		# Проверка, что ноды найдены
		if current_node:
			current_node.is_symmetrical = toggled_on
		else:
			print("Ошибка: Не найдена нода для", current_tab.name)
		
		if linked_node:
			linked_node.is_symmetrical = toggled_on
		else:
			print("Ошибка: Не найдена нода для", linked_tab.name)
