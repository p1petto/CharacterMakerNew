extends MarginContainer

@onready var catallog_container = $CatalogContainer
@onready var button_container = $MarginContainer/HBoxContainer/ButtonsScrollContainer/HBoxContainer
@onready var button_scroll_container = $MarginContainer/HBoxContainer/ButtonsScrollContainer
@onready var character = $"../../SubViewportContainer/SubViewport/Character"
@onready var accessory_panel = $"../AccessoriePanel"
@onready var strand_panel = $"../StrandPanel"
var color_picker_button
var color_picker_button_border
@onready var color_picker_button_container =  $MarginContainer/HBoxContainer/ColorPickerButtons/ColorPickerButtonContainer
@onready var color_picker_button_container_border =  $MarginContainer/HBoxContainer/ColorPickerButtons/ColorPickerButtonContainerBorder
@onready var color_scheme_color_picker = $"../ColorSchemeColorPicker"
@onready var hint = $"../MarginContainer/HBoxContainer/Hint"
@export var current_tab: CustomTab

signal tab_changed

func _ready() -> void:
	call_deferred("_initialize_color_picker_button")

	for catalog_item in catallog_container.get_children():
		var new_slot = load("res://Scenes/UI/catalog_type_slot.tscn").instantiate()
		new_slot.tab_name = catalog_item.name
		
		button_container.add_child(new_slot)
		if catalog_item.icon:
			new_slot.set_texture(catalog_item.icon)
		else:
			new_slot.set_label(String(catalog_item.name))
			new_slot.label.visible = true
		
		
		if catalog_item.linked_symmetrical_element:
			var new_check_button = load("res://Scenes/UI/custom_check_button.tscn").instantiate()
			catalog_item.add_child(new_check_button)
			catalog_item.move_child(new_check_button, 0)
			new_check_button.button_toggled.connect(_on_check_button_toggled)
			var box_container = catalog_item.get_node("VBoxContainer")
			new_check_button.position.x = box_container.position.x
			
		
	for catalog_class in button_container.get_children():
		catalog_class.catalog_tab_changed.connect(_on_catalog_tab_changed)
		
	await get_tree().process_frame
	hint.array_hints = current_tab.hint_resource
	hint.initialize()

func _initialize_color_picker_button() -> void:
	color_picker_button = color_picker_button_container.get_node(NodePath(current_tab.name))  
	color_picker_button.visible = true
	if current_tab.is_in_group("ConditionallyDynamicTab") or current_tab.is_in_group("DynamicTab"):
		color_picker_button_border= color_picker_button_container_border.get_node(NodePath(current_tab.name))  
		color_picker_button_border.visible = true
	elif current_tab.is_in_group("HairTab"):
		if current_tab.catalog_items[0].hair.has_line:
			color_picker_button_border= color_picker_button_container_border.get_node(NodePath(current_tab.name))  
			color_picker_button_border.visible = true
	elif current_tab.is_in_group("StaticClothesTab"):
		color_picker_button_border= color_picker_button_container_border.get_node(current_tab.catalog_items[0].static_clothing.name_clothing)  
		color_picker_button_border.visible = true
	

func _on_catalog_tab_changed(tab_name):
	current_tab.visible = false
	current_tab = find_tab(tab_name)
	current_tab.visible = true
	tab_changed.emit()
	color_picker_button.button_pressed = false
	color_picker_button.visible = false
	if color_picker_button_border:
		color_picker_button_border.button_pressed = false
		color_picker_button_border.visible = false
	color_scheme_color_picker.visible = false
	if !current_tab.is_in_group("Accessorie") and !current_tab.is_in_group("SettingsTab") and !current_tab.is_in_group("HairStrandTab"):
		_initialize_color_picker_button()
		color_picker_button.visible = true
	elif current_tab.is_in_group("SettingsTab"):
		color_scheme_color_picker.visible = true
	
	if current_tab.is_in_group("Accessorie"):
		accessory_panel.visible = true
		strand_panel.visible = false
	elif current_tab.is_in_group("HairStrandTab"):
		strand_panel.visible = true
		accessory_panel.visible = false
	else:
		accessory_panel.visible = false
		strand_panel.visible = false
		
	hint.array_hints = current_tab.hint_resource
	hint.initialize()
		

func find_tab(tab_name):
	return catallog_container.get_node(tab_name)

func _on_check_button_toggled(toggled_on):
	var linked_tab = current_tab.linked_symmetrical_element
	if linked_tab:
		var linked_check_button = linked_tab.get_node("CustomCheckButton")
		if linked_check_button and linked_check_button.get_node("VBoxContainer/CheckButton").button_pressed != toggled_on:
			linked_check_button.get_node("VBoxContainer/CheckButton").set_pressed_no_signal(toggled_on)
			linked_check_button.change_icon(toggled_on)
		
		var linked_node
		var current_node
		if !current_tab.is_in_group("DynamicClothesTab") and !current_tab.is_in_group("StaticClothesTab"):
			current_node = character.find_child(str(current_tab.name), true, false)
			linked_node = character.find_child(str(linked_tab.name), true, false)
			
		elif current_tab.is_in_group("DynamicClothesTab"):
			current_node = character.find_child(str(current_tab.catalog_items[0].item_class), true, false)
			linked_node = character.find_child(str(current_tab.linked_symmetrical_element.catalog_items[0].item_class), true, false)
			if current_tab.catalog_items[0].dynamic_clothes.is_flooded_inside:
				current_node = current_node.find_child("DynamicClothes", true, false)
				linked_node = linked_node.find_child("DynamicClothes", true, false)
			else:
				current_node = current_node.find_child("TipWear", true, false)
				linked_node = linked_node.find_child("TipWear", true, false)
				
			
		current_node.is_symmetrical = toggled_on
		linked_node.is_symmetrical = toggled_on
		
