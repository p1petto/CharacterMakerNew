extends MarginContainer

@onready var catallog_container = $CatalogContainer
@onready var button_container = $ButtonsScrollContainer/HBoxContainer

@export var current_tab: CustomTab

signal tab_changed

func _ready() -> void:
	for catalog_item in catallog_container.get_children():
		var new_slot = load("res://Scenes/UI/catalog_type_slot.tscn").instantiate()
		new_slot.tab_name = catalog_item.name
		button_container.add_child(new_slot)
		
	for catalog_slass in button_container.get_children():
		catalog_slass.catalog_tab_changed.connect(_on_catalog_tab_changed)

func _on_catalog_tab_changed(tab_name):
	current_tab.visible = false
	current_tab = find_tab(tab_name)
	current_tab.visible = true
	tab_changed.emit()
	pass
	
func find_tab(tab_name):
	return catallog_container.get_node(tab_name)
