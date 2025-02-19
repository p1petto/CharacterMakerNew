extends HBoxContainer

@onready var catallog = $"../../CatalogContainer"

@export var current_tab: CustomTab

func _ready() -> void:
	for catalog_item in catallog.get_children():
		var new_slot = load("res://Scenes/UI/catalog_type_slot.tscn").instantiate()
		new_slot.tab_name = catalog_item.name
		add_child(new_slot)
		
