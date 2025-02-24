extends MarginContainer

@onready var catallog_container = $CatalogContainer
@onready var button_container = $ButtonsScrollContainer/HBoxContainer
@onready var button_scroll_container = $ButtonsScrollContainer

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
