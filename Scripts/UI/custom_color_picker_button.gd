extends Button

@onready var color_picker = $ColorPicker

#@export var bg_color: Color

var catallog
var slider_container
var position_container
var character

signal color_changed

func _ready() -> void:
	var root = get_tree().root
	catallog = root.find_child("Catalog", true, false)
	slider_container = root.find_child("SliderContainer", true, false)
	position_container = root.find_child("PositionController", true, false)
	#character = root.find_child("Character", true, false)
	#
	#var target_child = character.find_child(self.name, false, false)
	#if target_child:
		#target_child.color_picker_button = self

	

func _on_toggled(toggled_on: bool) -> void:
	if toggled_on:
		color_picker.global_position = Vector2(800,40)
		color_picker.visible = true
		slider_container.visible = false
		position_container.visible = false
	else:
		color_picker.visible = false
		if catallog and catallog.current_tab:
			catallog._on_catalog_tab_changed(str(catallog.current_tab.name))


func _on_color_picker_color_changed(color: Color) -> void:
	set_new_bg_color(color)
	color_changed.emit(color)
	
	
func set_new_bg_color(color:Color)-> void:
	var normal_bg_color = StyleBoxFlat.new()
	normal_bg_color.bg_color = color
	add_theme_stylebox_override("normal", normal_bg_color)
