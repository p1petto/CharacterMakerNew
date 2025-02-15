extends Container

@onready var catallog = $"../Catalog"
@onready var character = $"../../SubViewportContainer/SubViewport/Character"

var slider_scene = preload("res://Scenes/custom_h_slider.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for part in character.get_children():
		if part.is_in_group("Dynamic"):
			for marker in part.dynamic_part.markers:
				var slider = slider_scene.instantiate()
				var polygon_2d = part.get_node("Polygon2D")
				slider.position.y = slider.position.y + polygon_2d.polygon[marker].y * 5 + part.position.y * 5
				add_child(slider)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
