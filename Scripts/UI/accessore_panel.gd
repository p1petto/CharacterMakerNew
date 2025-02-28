extends MarginContainer

@onready var catallog = $"../Catalog"
@onready var button_container = $VScrollBar/VBoxContainer

@export var accessories: Array[Accessorie]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	catallog.tab_changed.connect(_on_tab_changed)
	$"../Catalog/CatalogContainer/Accessories".added_accessorie.connect(_on_list_accessorie_changed)
	
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

func _on_list_accessorie_changed():
	add_accessorie_button(accessories[len(accessories)-1])
