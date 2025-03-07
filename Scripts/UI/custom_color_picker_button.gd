extends Button
@onready var color_picker = $ColorPicker
var catallog
var slider_container
var position_container

func _ready() -> void:
	var root = get_tree().root
	catallog = root.find_child("Catalog", true, false)
	slider_container = root.find_child("SliderContainer", true, false)
	position_container = root.find_child("PositionController", true, false)
	

func _on_toggled(toggled_on: bool) -> void:
	if toggled_on:
		color_picker.visible = true
		slider_container.visible = false
		position_container.visible = false
	else:
		color_picker.visible = false
		if catallog and catallog.current_tab:
			catallog._on_catalog_tab_changed(str(catallog.current_tab.name))
