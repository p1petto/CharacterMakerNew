extends MarginContainer

@onready var catallog = $"../Catalog"
@onready var button_container = $VScrollBar/VBoxContainer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	catallog.tab_changed.connect(_on_tab_changed)
	
	
func _on_tab_changed():
	visible = catallog.current_tab.is_in_group("Accessorie")

#func add_accessorie_button(button):
	#button_container.add_child(button)
