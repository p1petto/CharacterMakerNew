extends TextureButton

@onready var color_picker = $ColorPicker


var catallog
var slider_container
var position_container
var character
var accessory_panel
var strand_panel

signal color_changed

func _ready() -> void:
	var root = get_tree().root
	catallog = root.find_child("Catalog", true, false)
	slider_container = root.find_child("SliderContainer", true, false)
	position_container = root.find_child("PositionController", true, false)
	accessory_panel = root.find_child("AccessoriePanel", true, false)
	strand_panel = root.find_child("StrandPanel", true, false)
	material = ShaderMaterial.new()
	var shader = load("res://Scripts/Shaders/static_color_changing_shader.gdshader")  
	material.shader = shader
	self.material = material  
	material.set_shader_parameter("oldcolor", Color(1,1,1))

	

func _on_toggled(toggled_on: bool) -> void:
	if toggled_on:
		var root = get_tree().root
		var target_node = root.get_node("Maker/UI/ColorSchemeColorPicker")
		if target_node:
			var target_global_pos = target_node.get_global_position()
			color_picker.global_position = target_global_pos
			print(target_global_pos)
			print(color_picker.global_position)
			
		color_picker.visible = true
		slider_container.visible = false
		position_container.visible = false
	else:
		color_picker.visible = false
		if catallog and catallog.current_tab:
			catallog._on_catalog_tab_changed(str(catallog.current_tab.name))
		
		if catallog.current_tab.is_in_group("Accessorie"):
			if accessory_panel.active_button != null:
				position_container.visible = true
		elif catallog.current_tab.is_in_group("HairStrandTab"):
			if strand_panel.active_button != null:
				position_container.visible = true


func _on_color_picker_color_changed(color: Color) -> void:
	set_new_bg_color(color)
	color_changed.emit(color)
	
	
func set_new_bg_color(color:Color)-> void:
	material.set_shader_parameter("newcolor", color)
