extends Node2D

@onready var head = $Head
@onready var catallog = $"../../../UI/Catalog"

func _ready() -> void:
	for part in catallog.get_children():
		part.part_changed.connect(_on_part_changed)

func _process(delta: float) -> void:
	pass

func _on_part_changed(current_node, dynamic_part):
	print("Part changed: ", current_node.name)
	current_node.setup_polygon()
