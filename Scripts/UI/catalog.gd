extends MarginContainer

@onready var catallog_container = $CatalogContainer
@onready var button_container = $ButtonsScrollContainer/HBoxContainer
@onready var button_scroll_container = $ButtonsScrollContainer
@onready var character = $"../../SubViewportContainer/SubViewport/Character"

@export var current_tab: CustomTab

signal tab_changed

func _ready() -> void:
	for catalog_item in catallog_container.get_children():
		var new_slot = load("res://Scenes/UI/catalog_type_slot.tscn").instantiate()
		new_slot.tab_name = catalog_item.name
		button_container.add_child(new_slot)
		
		if catalog_item.linked_symmetrical_element:
			var new_check_button = load("res://Scenes/UI/custom_check_button.tscn").instantiate()
			var container = catalog_item.get_node("VBoxContainer")
			container.add_child(new_check_button)
			container.move_child(new_check_button, 0)
			new_check_button.button_toggled.connect(_on_check_button_toggled)
		
	for catalog_class in button_container.get_children():
		catalog_class.catalog_tab_changed.connect(_on_catalog_tab_changed)

func _on_catalog_tab_changed(tab_name):
	current_tab.visible = false
	current_tab = find_tab(tab_name)
	current_tab.visible = true
	tab_changed.emit()
	pass
	
func find_tab(tab_name):
	return catallog_container.get_node(tab_name)
	
func _on_check_button_toggled(toggled_on):
	# Find the check button in the linked symmetrical element
	var linked_tab = current_tab.linked_symmetrical_element
	if linked_tab:
		var linked_check_button = linked_tab.get_node("VBoxContainer/CustomCheckButton")
		
		# Check if the button exists and its state is different from toggled_on
		if linked_check_button and linked_check_button.get_node("CheckButton").button_pressed != toggled_on:
			# Set the linked button's state without triggering signals
			linked_check_button.get_node("CheckButton").set_pressed_no_signal(toggled_on)
	
	
	
		var current_node = character.find_child(current_tab.name, true, false)
		if current_node:
			current_node.is_symmetrical = toggled_on

		var linked_node = character.find_child(linked_tab.name, true, false)
		if linked_node:
			linked_node.is_symmetrical = toggled_on
