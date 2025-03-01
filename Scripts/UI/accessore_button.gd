extends MarginContainer
class_name AccessorieButton

@onready var button = $MarginContainer/TextureButton
@export var accessorie: Accessorie
@export var accessorie_element: AccessorieElement
var dragging: bool = false
var offset: Vector2
var cur_position: Vector2

signal position_changed
signal accessory_selected

func _ready() -> void:
	button.texture_normal = accessorie.down_texture
	# Используем таймер для задержки, чтобы дать VBoxContainer время разместить ноды
	var timer = get_tree().create_timer(0.05)
	timer.timeout.connect(_update_position)

# Этот метод обновит cur_position после того, как узел был полностью размещен в сцене
func _update_position() -> void:
	cur_position = position

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
	accessory_selected.emit(accessorie_element)
