extends MarginContainer
class_name AccessorieButton

@onready var icon = $CenterContainer/icon
@onready var color_picker_button = $Container/CustomColorPickerButton

@export var accessorie: Accessorie
@export var accessorie_element: AccessorieElement


var dragging: bool = false
var offset: Vector2
var cur_position: Vector2
var is_selected = false

signal position_changed
signal accessory_selected
signal element_deleted

func _ready() -> void:
	icon.texture = accessorie.texture_icon
	
	#var timer = get_tree().create_timer(0.05)
	#timer.timeout.connect(_update_position)

#func _update_position() -> void:
	#cur_position = position

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
	accessory_selected.emit(accessorie_element)
	


func _on_delete_button_button_up() -> void:
	# Удаляем элемент аксессуара, если он существует
	element_deleted.emit(self)
	if accessorie_element != null and is_instance_valid(accessorie_element):
		accessorie_element.queue_free()
	
	# Удаляем саму кнопку (текущий объект)
	queue_free()
	
