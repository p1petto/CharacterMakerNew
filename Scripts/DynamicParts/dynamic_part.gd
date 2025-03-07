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

func _ready() -> void:
	if dynamic_part:
		setup_polygon("down")
	flag = false	
	call_deferred("_connect_color_changed_signal")

func _connect_color_changed_signal():
	color_picker_button.color_changed.connect(_on_color_changed)
	
func _on_color_changed(new_color: Color) -> void:
	print("Color changed to: ", new_color)
		
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
