extends Node2D

@onready var head = $Head
@onready var body = $Body

@onready var catallog = $"../../../UI/Catalog/CatalogContainer"
@onready var direction_controller = $"../../../UI/DirectionButtons"

var cur_dir = "down"

signal direction_change_sliders

func _ready() -> void:
	for button in direction_controller.get_children():
		button.direction_changed.connect(_on_direction_changed)

func _process(delta: float) -> void:
	pass

func _on_direction_changed(dir):
	if cur_dir != dir:
		cur_dir = dir
		print ("current direction = ", cur_dir)
		change_dir_for_parts()
		direction_change_sliders.emit(cur_dir)
		
func change_dir_for_parts():
	for child in get_children():
		if child.is_in_group("Dynamic"):
			child.setup_polygon(cur_dir)
		elif child.is_in_group("ConditionallyDynamic"):
			child.change_direction(cur_dir)
