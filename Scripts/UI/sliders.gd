extends Container

@onready var catallog = $"../Catalog"
@onready var character = $"../../SubViewportContainer/SubViewport/Character"
var slider_scene = preload("res://Scenes/custom_h_slider.tscn")

func _ready() -> void:
	for part in character.get_children():
		if part.is_in_group("Dynamic"):
			if part.dynamic_part.markers:
				var part_container = VBoxContainer.new()
				part_container.name = part.name
				
				# Get the position of the first marker
				var polygon_2d = part.get_node("Polygon2D")
				var first_marker = part.dynamic_part.markers[0]
				part_container.position.y = polygon_2d.polygon[first_marker].y * 5 + part.position.y * 5
				
				add_child(part_container)
				
				for marker in part.dynamic_part.markers:
					var slider = slider_scene.instantiate()
					part_container.add_child(slider)
					
		if part.is_in_group("ConditionallyDynamic"):
			var part_container = VBoxContainer.new()
			part_container.name = part.name
			
			part_container.position.y = part.marker_y_pos * 5
			
			add_child(part_container)
			var slider = slider_scene.instantiate()
			part_container.add_child(slider)

	# Get current tab's name from catalog's child
	var current_part_name = catallog.get_child(catallog.current_tab).name
	
	# Hide all containers except the one matching current tab's name
	for container in get_children():
		container.visible = (container.name == current_part_name)

func _process(delta: float) -> void:
	pass

func _on_catalog_tab_changed(tab: int) -> void:
	var current_part_name = catallog.get_child(tab).name
	for container in get_children():
		container.visible = (container.name == current_part_name)
