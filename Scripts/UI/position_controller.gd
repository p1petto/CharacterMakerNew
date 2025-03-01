extends ColorRect

@onready var catallog = $"../Catalog"
@onready var character = $"../../SubViewportContainer/SubViewport/Character"

var cur_element

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in get_children():
		child.change_position.connect(_on_position_changed)
		
	catallog.tab_changed.connect(_on_tab_changed)

func _on_tab_changed():
	visible = catallog.current_tab.is_in_group("StaticTab") 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_position_changed(val):
	cur_element = character.find_child(catallog.current_tab.name, true, false)
	
	if !cur_element:
		print("Ошибка: не найден cur_element")
		return
	
	if cur_element.name != "Accessories":
		cur_element.move_static_element(val)
	#else:
		#move_accesorie_element(val)

		
	


		
