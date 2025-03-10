extends Node2D

@export var dynamic_part: DynamicBodyPart

@export var idle_ainmation_offset_vertical: Array[Vector2]
@export var walk_animation_offset_vertical: Array[Vector2]
@export var idle_ainmation_offset_horizontal: Array[Vector2]
@export var walk_animation_offset_horizontal: Array[Vector2]

@onready var polygon2d = $Polygon2D
@onready var testpolygon2d = $Polygon2D
@onready var line2d = $Line2D
@onready var glare = $Polygon2D/glare

@onready var slider_containers = $"../../../../UI/SliderContainer"
@onready var character = $".."

var central_bottom_point: int 
var flag = true

var color_picker_button
var cur_color: Color

func _ready() -> void:
	if dynamic_part:
		setup_polygon("down")
	flag = false	
	call_deferred("_connect_color_changed_signal")
	call_deferred("_connect_color")

func _connect_color_changed_signal():
	color_picker_button.color_changed.connect(_on_color_changed)
	
func _connect_color():
	cur_color = dynamic_part.color
	color_picker_button._on_color_picker_color_changed(cur_color)
	material.set_shader_parameter("cur_color", cur_color)

func set_start_color():
	cur_color = dynamic_part.color  # Восстанавливаем исходный цвет
	if material:
		material.set_shader_parameter("cur_color", cur_color)
	
	# Восстанавливаем изначальный цвет Polygon2D
	if polygon2d:
		polygon2d.color = cur_color
	
	# Восстанавливаем изначальный цвет Line2D
	if line2d:
		line2d.default_color = dynamic_part.line_color
	
	# Восстанавливаем изначальный цвет Glare
	if glare:
		glare.color = dynamic_part.glare_color

	
func _on_color_changed(new_color: Color) -> void:
	print(self.name, "Color changed to: ", new_color)
	cur_color = new_color
	
	# Применить шейдер к материалу, если он есть
	if material:
		material.set_shader_parameter("cur_color", cur_color)
	
	# Коэффициент смешивания
	var interpolation_factor = 0.6
	var base_glare_color = dynamic_part.glare_color
	var base_line_color = dynamic_part.line_color
	
	# Для Polygon2D
	if polygon2d:
		# Используем точную формулу из примера для основного полигона
		var r = (polygon2d.color.r - cur_color.r) * interpolation_factor + cur_color.r
		var g = (polygon2d.color.g - cur_color.g) * interpolation_factor + cur_color.g
		var b = (polygon2d.color.b - cur_color.b) * interpolation_factor + cur_color.b
		polygon2d.color = Color(r, g, b, polygon2d.color.a)
	
	# Для Line2D используем dynamic_part.line_color как базовый цвет
	if line2d and dynamic_part:
		# Смешиваем базовый цвет линии с текущим цветом
		var line_r = lerp(base_line_color.r, cur_color.r, 0.4)
		var line_g = lerp(base_line_color.g, cur_color.g, 0.4)
		var line_b = lerp(base_line_color.b, cur_color.b, 0.4)
		line2d.default_color = Color(line_r, line_g, line_b, line2d.default_color.a)
	
	# Для glare используем dynamic_part.glare_color как базовый цвет
	if glare and dynamic_part:
		# Смешиваем базовый цвет блика с текущим цветом
		var glare_r = lerp(base_glare_color.r, cur_color.r, 0.3) 
		var glare_g = lerp(base_glare_color.g, cur_color.g, 0.3)
		var glare_b = lerp(base_glare_color.b, cur_color.b, 0.3)
		glare.color = Color(glare_r, glare_g, glare_b, glare.color.a)

		
func get_target_container_slider():
	var character_part = get_name()
	#var cur_dir = character.cur_dir
	var cur_dir = Global.current_dir
	var axis
	if cur_dir == "top" or cur_dir == "down":
		axis = "_vertical"
	else:
		axis = "_horizontal"
	var target_container_slider = slider_containers.get_node(character_part+axis)
	return target_container_slider

func setup_polygon(dir) -> void:
	var sliders
	if !flag:
		sliders = get_target_container_slider().get_children()
		#print(get_target_container_slider().name)
	if dir == "down":
		polygon2d.polygon = dynamic_part.down_array_points
		line2d.points = dynamic_part.down_array_points
		glare.polygon = dynamic_part.down_glare_array_points
		
		position = dynamic_part.position_down
	
		
		z_index = dynamic_part.z_down
		
		central_bottom_point = len(dynamic_part.down_array_points) / 2
		
		if !flag:
			for slider in sliders:
				polygon2d.polygon[slider.linked_marker].x = dynamic_part.down_array_points[slider.linked_marker].x - slider.value
				line2d.points[slider.linked_marker].x = dynamic_part.down_array_points[slider.linked_marker].x - slider.value
				var mirror_x = get_mirror_x(len(dynamic_part.down_array_points), slider.linked_marker)
				polygon2d.polygon[mirror_x].x = dynamic_part.down_array_points[mirror_x].x + slider.value
				line2d.points[mirror_x].x = dynamic_part.down_array_points[mirror_x].x + slider.value
		
	if dir == "top":
		polygon2d.polygon = dynamic_part.top_array_points
		line2d.points = dynamic_part.top_array_points
		glare.polygon = dynamic_part.top_glare_array_points
		
		position = dynamic_part.position_top
		z_index = dynamic_part.z_top
		
		central_bottom_point = len(dynamic_part.top_array_points) / 2
		
		if !flag:
			for slider in sliders:
				polygon2d.polygon[slider.linked_marker].x = dynamic_part.top_array_points[slider.linked_marker].x - slider.value
				line2d.points[slider.linked_marker].x = dynamic_part.top_array_points[slider.linked_marker].x - slider.value
				var mirror_x = get_mirror_x(len(dynamic_part.top_array_points), slider.linked_marker)
				polygon2d.polygon[mirror_x].x = dynamic_part.top_array_points[mirror_x].x + slider.value
				line2d.points[mirror_x].x = dynamic_part.top_array_points[mirror_x].x + slider.value			
				
	if dir == "right":
		polygon2d.polygon = dynamic_part.horizontal_array_points
		glare.polygon = dynamic_part.horizontal_glare_array_points
		
		# Сначала обновляем полигон с учетом слайдеров
		if !flag:
			for slider in sliders:
				polygon2d.polygon[slider.linked_marker].x += slider.value

		# Теперь синхронизируем line2d с polygon2d
		line2d.points = polygon2d.polygon.duplicate()

		position = dynamic_part.position_right
		z_index = dynamic_part.z_right

		central_bottom_point = len(dynamic_part.horizontal_array_points) / 2


	if dir == "left":
		# Начинаем с оригинальных точек горизонтального набора
		polygon2d.polygon = dynamic_part.horizontal_array_points.duplicate()
		glare.polygon = dynamic_part.horizontal_glare_array_points.duplicate()
		
		# Применяем изменения от слайдеров (аналогично как в right)
		if !flag:
			sliders = get_target_container_slider().get_children()
			for slider in sliders:
				polygon2d.polygon[slider.linked_marker].x += slider.value
		
		# Теперь зеркалим все точки полигона
		var mirrored_points = []
		for point in polygon2d.polygon:
			mirrored_points.append(Vector2(7 - (point.x - 7), point.y))
		
		# Зеркалим блики
		var mirrored_glare_points = []
		for point in glare.polygon:
			mirrored_glare_points.append(Vector2(7 - (point.x - 7), point.y))
		
		# Применяем зеркальные координаты
		polygon2d.polygon = mirrored_points
		glare.polygon = mirrored_glare_points
		line2d.points = polygon2d.polygon.duplicate()
		
		position = dynamic_part.position_left
		z_index = dynamic_part.z_left
		
		central_bottom_point = len(dynamic_part.horizontal_array_points) / 2



func get_mirror_x(count_of_points, marker):
	if count_of_points % 2 == 0:
		return count_of_points - marker
	return count_of_points - marker - 1
