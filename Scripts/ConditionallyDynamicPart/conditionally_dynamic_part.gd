extends Node2D

class_name ConditionallyDynamicCharacterPart

@onready var animated_sprite = $AnimatedSprite2D
@onready var body = $"../Body"

@export var conditionally_dynamic: ConditionallyDynamic

@export var z_down: float
@export var z_right: float
@export var z_top: float
@export var z_left: float

@export var marker_y_pos: int = 0

@export var linked_symmetrical_element: ConditionallyDynamicCharacterPart

@export var cur_animation: String

@export var idle_ainmation_offset_vertical: Array[Vector2]
@export var walk_animation_offset_vertical: Array[Vector2]
@export var idle_ainmation_offset_horizontal: Array[Vector2]
@export var walk_animation_offset_horizontal: Array[Vector2]


@onready var slider_containers = $"../../../../UI/SliderContainer"

var current_state: String = "idle"
var current_direction: String = "down"
var current_thickness: String = "1"
var is_symmetrical = false
var start_position: Vector2

var color_picker_button
var cur_color: Color
var start_color: Color

func _ready() -> void:
	
	if conditionally_dynamic.sprite_frames:
		animated_sprite.sprite_frames = conditionally_dynamic.sprite_frames
	if cur_animation:
		animated_sprite.animation = cur_animation
	else:
		# Установка анимации по умолчанию
		update_animation()
	start_position = position
	call_deferred("_connect_color_changed_signal")
	call_deferred("_connect_color")

func _connect_color_changed_signal():
	color_picker_button.color_changed.connect(_on_color_changed)
	
func _connect_color():
	cur_color = conditionally_dynamic.color
	color_picker_button._on_color_picker_color_changed(cur_color)
	color_picker_button.color_picker.color = cur_color
	start_color = cur_color
	set_start_color()
	
func set_start_color() -> void:
	# Устанавливаем стартовый цвет белым
	cur_color = start_color

	# Создаём ShaderMaterial у корневой ноды, если его ещё нет
	if not material:
		var shader_material = ShaderMaterial.new()
		var shader = load("res://path_to_your_shader.gdshader")  # Укажите правильный путь
		shader_material.shader = shader
		material = shader_material

	# Устанавливаем стартовый цвет в шейдер
	material.set_shader_parameter("cur_color", cur_color)
	material.set_shader_parameter("blend_factor", 0.9)

	# Применяем цвет к animated_sprite с разницей от белого
	if animated_sprite:
		# Это нужно, чтобы modulate был правильно рассчитан
		animated_sprite.modulate = cur_color

	# Устанавливаем стартовый цвет для симметричного элемента, если он есть
	if linked_symmetrical_element and is_symmetrical:
		# Применяем цвет к симметричному элементу, но без рекурсии
		linked_symmetrical_element.set_start_color_without_recursive()

	color_picker_button.color_picker.color = cur_color


# Функция для установки цвета на симметричный элемент без рекурсии
func set_start_color_without_recursive() -> void:
	# Устанавливаем стартовый цвет белым для симметричного элемента
	cur_color = start_color

	# Создаём ShaderMaterial у корневой ноды, если его ещё нет
	if not material:
		var shader_material = ShaderMaterial.new()
		var shader = load("res://path_to_your_shader.gdshader")  # Укажите правильный путь
		shader_material.shader = shader
		material = shader_material

	# Устанавливаем стартовый цвет в шейдер
	material.set_shader_parameter("cur_color", cur_color)
	material.set_shader_parameter("blend_factor", 0.9)

	# Применяем цвет к animated_sprite с разницей от белого
	if animated_sprite:
		# Это нужно, чтобы modulate был правильно рассчитан
		animated_sprite.modulate = cur_color

		
func _on_color_changed(new_color: Color) -> void:
	print(self.name, "Color changed to: ", new_color)
	
	# Сохраняем cur_color как новый цвет без изменений
	cur_color = new_color

	# Вычисляем разницу между new_color и белым цветом для шейдера
	var adjusted_color = new_color 

	# Создаём ShaderMaterial у корневой ноды, если его ещё нет
	if not material:
		var shader_material = ShaderMaterial.new()
		var shader = load("res://path_to_your_shader.gdshader")  # Укажите правильный путь
		shader_material.shader = shader
		material = shader_material

	# Обновляем параметры шейдера с учётом разницы с белым
	material.set_shader_parameter("cur_color", cur_color)
	material.set_shader_parameter("blend_factor", 0.9)

	# Применяем цвет, с учётом разницы с белым для `animated_sprite`
	if animated_sprite:
		animated_sprite.modulate = cur_color 

	# Если есть симметричный элемент, обновляем его отдельно
	if linked_symmetrical_element and is_symmetrical:
		linked_symmetrical_element._apply_color_without_propagation(new_color)

# Функция для обновления цвета у симметричного элемента без рекурсии
func _apply_color_without_propagation(new_color: Color) -> void:
	if not material:
		var shader_material = ShaderMaterial.new()
		var shader = load("res://path_to_your_shader.gdshader")  # Укажите правильный путь
		shader_material.shader = shader
		material = shader_material

	# Применяем цвет с разницей с белым
	material.set_shader_parameter("cur_color", new_color)
	material.set_shader_parameter("blend_factor", 0.9)

	# Обновляем цвет `animated_sprite` с разницей с белым
	if animated_sprite:
		animated_sprite.modulate = new_color


func change_direction(direction: String) -> void:
	if direction not in ["top", "down", "left", "right"]:
		return
		
	match direction:
		"down":
			z_index = z_down
		"right":
			z_index = z_right
		"top":
			z_index = z_top
		"left":
			z_index = z_left
			
	current_direction = direction
	update_animation()

func change_state(new_state: String) -> void:
	current_state = new_state
	update_animation()

func change_thickness(new_thickness) -> void:
	current_thickness = str(new_thickness)
	update_animation()

func update_animation() -> void:
	# Собираем имя анимации из компонентов через underscore
	animated_sprite.sprite_frames = conditionally_dynamic.sprite_frames
	var animation_name = "_".join([current_state, current_direction, current_thickness])
	
	# Проверяем, существует ли такая анимация
	if animated_sprite.sprite_frames.has_animation(animation_name):
		animated_sprite.animation = animation_name
	else:
		print("Animation not found: ", animation_name)
	
	#if Global.animation_is_run:
		#var property_name = ""
		#if Global.current_animation == "idle":
			#property_name = "idle_ainmation_offset"
		#elif Global.current_animation == "walk":
			#property_name = "walk_animation_offset"
		#else:
			#property_name = "idle_ainmation_offset"  # По умолчанию
		#if Global.current_dir == "down" or Global.current_dir == "top":
			#property_name = property_name + "_vertical"
		#else:
			#property_name = property_name + "_horizontal"
			#
		#var offset_array = get(property_name)
		#position = start_position + offset_array[cur_frame]

func _process(delta: float) -> void:
	pass
	
func update_frame(frame_index):
	animated_sprite.frame = frame_index
