extends MarginContainer
class_name AccessorieButton

@onready var icon = $CenterContainer/TextureButton/CenterContainer/icon
@onready var color_picker_button = $MarginContainerColorPickerButtons/Container/MarginContainer1/CustomColorPickerButton
@onready var color_picker_button_line = $MarginContainerColorPickerButtons/Container/MarginContainer2/CustomColorPickerButtonLine
@onready var margin_container1 = $MarginContainerColorPickerButtons/Container/MarginContainer1
@onready var margin_container2 = $MarginContainerColorPickerButtons/Container/MarginContainer2
@onready var slot = $CenterContainer/TextureButton
@onready var flip_button = $FlipButtonContainer/FlipButton

@export var accessory: Accessorie
@export var accessory_element: AccessorieElement
@export var non_active_texture: CompressedTexture2D
@export var active_texture: CompressedTexture2D


var dragging: bool = false
var offset: Vector2
var cur_position: Vector2
var is_selected = false
var toggled_on = false

var is_active = false

signal position_changed
signal accessory_selected
signal element_deleted
signal changed_active_status

func _ready() -> void:
	icon.texture = accessory.texture_icon
	color_picker_button_line.visible = false

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		# Если нажата кнопка мыши и мы находимся на этом объекте
		if event.pressed and get_global_rect().has_point(event.position):
			dragging = true
			offset = global_position - event.position
		# Если кнопка мыши отпускается, проверим, был ли это этот объект
		elif not event.pressed:
			if dragging:  # Только если этот объект перетаскивается
				dragging = false
				position_changed.emit(self)  # Вызываем сигнал при отпускании
	elif event is InputEventMouseMotion and dragging:
		global_position = event.position + offset

func _on_texture_button_button_up() -> void:
	is_selected = true
	accessory_selected.emit(self, accessory_element)
	


func _on_delete_button_button_up() -> void:
	is_active = true
	update_slot_texture()
	changed_active_status.emit(self)	
	
	element_deleted.emit(self)
	if accessory_element != null and is_instance_valid(accessory_element):
		accessory_element.queue_free()
	
	queue_free()


func _on_custom_color_picker_button_mouse_entered() -> void:
	margin_container1.add_theme_constant_override("margin_left", 0)


func _on_custom_color_picker_button_mouse_exited() -> void:
	if not color_picker_button.button_pressed:
		margin_container1.add_theme_constant_override("margin_left", 4)


func _on_custom_color_picker_button_line_mouse_entered() -> void:
	margin_container2.add_theme_constant_override("margin_left", 0)


func _on_custom_color_picker_button_line_mouse_exited() -> void:
	if not color_picker_button_line.button_pressed:
		margin_container2.add_theme_constant_override("margin_left", 4)


func _on_flip_button_pressed() -> void:
	toggled_on = !toggled_on
	accessory_element.flip_x(toggled_on)
	flip_button.flip_h = toggled_on
	is_active = true
	update_slot_texture()
	changed_active_status.emit(self)	

func update_slot_texture() -> void:
	if is_active:
		slot.texture_normal = active_texture
	else:
		slot.texture_normal = non_active_texture


func _on_custom_color_picker_button_button_up() -> void:
	is_active = true
	update_slot_texture()
	changed_active_status.emit(self)

func _on_custom_color_picker_button_line_button_up() -> void:
	is_active = true
	update_slot_texture()
	changed_active_status.emit(self)
