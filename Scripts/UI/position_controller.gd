extends ColorRect

@onready var catallog = $"../Catalog"
@onready var character = $"../../SubViewportContainer/SubViewport/Character"
@onready var accessory_panel = $"../AccessoriePanel"
@onready var strand_panel = $"../StrandPanel"

var cur_element

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in get_children():
		child.change_position.connect(_on_position_changed)
		
	catallog.tab_changed.connect(_on_tab_changed)
	accessory_panel.accessory_element_selected.connect(_on_aacessory_element_selected)
	strand_panel.accessory_element_selected.connect(_on_aacessory_element_selected)

func _on_tab_changed():
	visible = catallog.current_tab.is_in_group("StaticTab") 
	cur_element = character.find_child(catallog.current_tab.name, true, false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_position_changed(val):
		
	if !cur_element:
		print("Ошибка: не найден cur_element")
		return
			
	if cur_element.is_in_group("Static"):
		cur_element.move_static_element(val)
	elif cur_element.is_in_group("Accessorie"):
		cur_element.move_accesorie_element(val)

		
func _on_aacessory_element_selected(element):
	cur_element = element
	


		
