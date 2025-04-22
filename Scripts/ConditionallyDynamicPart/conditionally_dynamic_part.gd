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

#@export var resource_dynamic_clothes: DynamicClothes

@onready var slider_containers = $"../../../../UI/SliderContainer"
@onready var dynamic_clothes = $AnimatedSprite2D/DynamicClothes
@onready var tip_wear = $AnimatedSprite2D/TipWear
@onready var border = $AnimatedSpriteBorder


var current_state: String = "idle"
var current_direction: String = "down"
var current_thickness: String = "1"
var is_symmetrical = false
var start_position: Vector2

var color_picker_button
var color_picker_button_border
var cur_color: Color
var start_color: Color
@export var initial_line_color:Color

func _ready() -> void:
	
	if conditionally_dynamic.sprite_frames:
		animated_sprite.sprite_frames = conditionally_dynamic.sprite_frames
		border.sprite_frames = conditionally_dynamic.border_frames
	if cur_animation:
		animated_sprite.animation = cur_animation
		border.animation = cur_animation
	else:
		# Установка анимации по умолчанию
		update_animation()
	start_position = position
	call_deferred("_connect_color_changed_signal")
	call_deferred("_connect_color")
	
	dynamic_clothes.size = Vector2(0, 0)
	tip_wear.size = Vector2(0, 0)
	
	


func _connect_color_changed_signal():
	color_picker_button.color_changed.connect(_on_color_changed)
	color_picker_button_border.color_changed.connect(_on_border_color_changed)
	
func _connect_color():
	cur_color = conditionally_dynamic.color
	color_picker_button._on_color_picker_color_changed(cur_color)
	color_picker_button.color_picker.set_color_from_code(cur_color)
	start_color = cur_color
	set_start_color()
	
func set_start_color() -> void:
	# Устанавливаем стартовый цвет белым
	cur_color = start_color
	_on_color_changed(cur_color)
	_on_border_color_changed(initial_line_color)

func _on_color_changed(new_color: Color) -> void:
	
	# Сохраняем cur_color как новый цвет без изменений
	cur_color = new_color

	material.set_shader_parameter("cur_color", cur_color)
	material.set_shader_parameter("blend_factor", 0.9)

	# Применяем цвет, с учётом разницы с белым для `animated_sprite`
	if animated_sprite:
		animated_sprite.self_modulate = cur_color
		#border.self_modulate = cur_color

	# Если есть симметричный элемент, обновляем его отдельно
	if linked_symmetrical_element and is_symmetrical:
		linked_symmetrical_element._apply_color_without_propagation(new_color)
		linked_symmetrical_element.color_picker_button.set_new_bg_color(new_color)
		
func _on_border_color_changed(new_color: Color) -> void:
	border.self_modulate = new_color
	color_picker_button_border.set_new_bg_color(new_color)
	if linked_symmetrical_element and is_symmetrical:
		linked_symmetrical_element.border.self_modulate = new_color
		linked_symmetrical_element.color_picker_button_border.set_new_bg_color(new_color)

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
		animated_sprite.self_modulate = new_color
		#border.self_modulate = new_color


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
	if dynamic_clothes.resource_dynamic_clothes:
		dynamic_clothes.change_direction()
	if tip_wear.resource_dynamic_clothes:
		tip_wear.change_direction()

func change_state(new_state: String) -> void:
	current_state = new_state
	update_animation()
	if dynamic_clothes.resource_dynamic_clothes:
		dynamic_clothes.change_direction()
	if tip_wear.resource_dynamic_clothes:
		tip_wear.change_direction()	
		

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
		border.animation = animation_name
	else:
		print("Animation not found: ", animation_name)
	

func _process(delta: float) -> void:
	pass
	
func update_frame(frame_index):
	animated_sprite.frame = frame_index
	border.frame = frame_index
	
#func initialize_dynamic_clothes(clothes):
	#if clothes.is_flooded_inside:
		#dynamic_clothes.resource_dynamic_clothes = clothes
		#dynamic_clothes.change_direction()
		#dynamic_clothes.set_start_color()
	#else:
		#tip_wear.resource_dynamic_clothes = clothes
		#tip_wear.change_direction()
		#tip_wear.set_start_color()


func initialize_dynamic_clothes(clothes):
	# Создаем новый материал для каждого объекта одежды
	var shader = load("res://Scripts/Shaders/CD_color_rect_clothes.gdshader")  # Замените на фактический путь к вашему шейдеру
	
	if clothes.is_flooded_inside:
		# Инициализация для DynamicClothes
		dynamic_clothes.resource_dynamic_clothes = clothes
		
		# Создаем новый материал с собственными параметрами
		var dynamic_material = ShaderMaterial.new()
		dynamic_material.shader = shader
		dynamic_material.set_shader_parameter("is_flooded_inside", true)
		dynamic_material.set_shader_parameter("radius", 0.5)
		dynamic_material.set_shader_parameter("border_width", 0.0)
		dynamic_material.set_shader_parameter("border_color", Color(0, 0, 0, 1))
		
		# Применяем материал
		dynamic_clothes.material = dynamic_material
		
		# Обновляем состояние
		dynamic_clothes.change_direction()
		dynamic_clothes.set_start_color()
	else:
		# Инициализация для TipWear
		tip_wear.resource_dynamic_clothes = clothes
		
		# Создаем новый материал с собственными параметрами
		var tip_material = ShaderMaterial.new()
		tip_material.shader = shader
		tip_material.set_shader_parameter("is_flooded_inside", false)
		tip_material.set_shader_parameter("radius", 0.25)
		tip_material.set_shader_parameter("border_width", 0.0)
		tip_material.set_shader_parameter("border_color", Color(0, 0, 0, 1))
		
		# Применяем материал
		tip_wear.material = tip_material
		
		# Обновляем состояние
		tip_wear.change_direction()
		tip_wear.set_start_color()	
	
