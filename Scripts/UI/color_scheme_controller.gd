extends HBoxContainer
@onready var settings_container = $SettingsContainer
@onready var scheme_menu_button = $"SettingsContainer/СolorScheme/MarginContainer/SchemeMenuButton"
@onready var color_scheme_rects = $"SettingsContainer/СolorScheme/СolorSchemeRects"
@onready var character = $"../../../../../../SubViewportContainer/SubViewport/Character"
@onready var checkbox_controller = $SettingsContainer/CheckBoxes

var body_buttons = []
var clothes_buttons = []
var accessory_buttons = []
var hair_buttons = []

var color_scheme_rect_scene = "res://Scenes/color_scheme_rect.tscn"
var popup
var scheme_array = [2, 3, 3, 3, 4, 4]
var current_scheme_id = 0
var base_color = Color(1, 1, 1)  



func _ready() -> void:
	popup = scheme_menu_button.get_popup()
	popup.id_pressed.connect(on_id_pressed)
	
	if color_scheme_rects.get_child_count() > 0:
		set_new_bg_color(color_scheme_rects.get_child(0), base_color)
	
	if popup.item_count > 0:
		on_id_pressed(0)
		
	
	
func on_id_pressed(id):
	scheme_menu_button.text = popup.get_item_text(id)
	current_scheme_id = id
	
	clear_color_scheme_buttons()
	
	if id < scheme_array.size():
		var buttons_count = scheme_array[id]
		add_color_scheme_buttons(buttons_count)
			
	update_colors(base_color)
	
func clear_color_scheme_buttons():
	for i in range(color_scheme_rects.get_child_count() - 1, -1, -1):
		var child = color_scheme_rects.get_child(i)
		color_scheme_rects.remove_child(child)
		child.queue_free()
		
func add_color_scheme_buttons(count: int):
	for i in range(count):
		var button_instance = load(color_scheme_rect_scene).instantiate()
		color_scheme_rects.add_child(button_instance)
			
func set_new_bg_color(rect, color: Color) -> void:
	rect.change_color(color)

func update_colors(color: Color) -> void:
	if current_scheme_id >= scheme_array.size():
		return
	
	base_color = color
	
	var colors = get_colors_for_scheme(color)
	
	for i in range(color_scheme_rects.get_child_count()):
		if i < colors.size():
			set_new_bg_color(color_scheme_rects.get_child(i), colors[i])

func get_colors_for_scheme(color: Color) -> Array:
	var result = [color]  
	
	var additional_colors = []
	match current_scheme_id:
		0: # Комплиментарная
			additional_colors = calculate_complementary(color)
		1: # Триада
			additional_colors = calculate_triad(color)
		2: # Сплит-комплиментарная
			additional_colors = calculate_split_complementary(color)
		3: # Аналоговая триада
			additional_colors = calculate_analogous_triad(color)
		4: # Тетрада
			additional_colors = calculate_tetrad(color)
		5: # Монохромная
			additional_colors = calculate_monochromatic(color)
	
	# Добавляем дополнительные цвета к результату
	result.append_array(additional_colors)
	return result


func calculate_complementary(base_color: Color) -> Array:
	var h = fposmod(base_color.h + 0.5, 1.0) # Смещение на 180 градусов в HSV (0.5 = 180/360)
	return [Color.from_hsv(h, base_color.s, base_color.v)]

func calculate_triad(base_color: Color) -> Array:
	var h1 = fposmod(base_color.h + 1.0/3, 1.0) # +120 градусов
	var h2 = fposmod(base_color.h + 2.0/3, 1.0) # +240 градусов
	return [
		Color.from_hsv(h1, base_color.s, base_color.v),
		Color.from_hsv(h2, base_color.s, base_color.v)
	]

func calculate_split_complementary(base_color: Color) -> Array:
	var h_complement = fposmod(base_color.h + 0.5, 1.0) # Противоположный цвет
	var h1 = fposmod(h_complement - 1.0/12, 1.0) # -30 градусов
	var h2 = fposmod(h_complement + 1.0/12, 1.0) # +30 градусов
	return [
		Color.from_hsv(h1, base_color.s, base_color.v),
		Color.from_hsv(h2, base_color.s, base_color.v)
	]

func calculate_analogous_triad(base_color: Color) -> Array:
	var h1 = fposmod(base_color.h - 1.0/12, 1.0) # -30 градусов
	var h2 = fposmod(base_color.h + 1.0/12, 1.0) # +30 градусов
	return [
		Color.from_hsv(h1, base_color.s, base_color.v),
		Color.from_hsv(h2, base_color.s, base_color.v)
	]

func calculate_tetrad(base_color: Color) -> Array:
	var h1 = fposmod(base_color.h + 1.0/4, 1.0) # +90 градусов
	var h2 = fposmod(base_color.h + 2.0/4, 1.0) # +180 градусов
	var h3 = fposmod(base_color.h + 3.0/4, 1.0) # +270 градусов
	return [
		Color.from_hsv(h1, base_color.s, base_color.v),
		Color.from_hsv(h2, base_color.s, base_color.v),
		Color.from_hsv(h3, base_color.s, base_color.v)
	]

func calculate_monochromatic(base_color: Color) -> Array:
	var s1 = max(base_color.s - 0.3, 0.0)
	var v1 = min(base_color.v + 0.1, 1.0)
	
	var s2 = min(base_color.s + 0.2, 1.0)
	var v2 = max(base_color.v - 0.2, 0.0)
	
	var s3 = max(base_color.s - 0.1, 0.0)
	var v3 = max(base_color.v - 0.3, 0.0)
	
	return [
		Color.from_hsv(base_color.h, s1, v1),
		Color.from_hsv(base_color.h, s2, v2),
		Color.from_hsv(base_color.h, s3, v3)
	]

func _on_accept_button_up() -> void:
	for index in checkbox_controller.check_button_pressed:
		set_color_scheme(index)
		
		
func set_color_scheme(checkbox_index):
	var buttons_array = []
	
	match checkbox_index:
		0: 
			buttons_array = body_buttons
		1:
			buttons_array = clothes_buttons
		2:
			buttons_array = accessory_buttons 
		3:
			buttons_array = hair_buttons

	var colors = get_colors_for_scheme(base_color)
	var colors_count = colors.size()

	for i in range(buttons_array.size()):
		var button = buttons_array[i]
		if button.has_method("_on_color_picker_color_changed"):
			var color_index = i % colors_count  # Цикличный выбор цветов
			button._on_color_picker_color_changed(colors[color_index])


func _on_color_scheme_color_picker_color_changed(color: Color) -> void:
	update_colors(color)
