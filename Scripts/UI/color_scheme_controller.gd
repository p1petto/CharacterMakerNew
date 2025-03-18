extends HBoxContainer
@onready var settings_container = $SettingsContainer
@onready var scheme_menu_button = $SettingsContainer/SchemeMenuButton
@onready var color_scheme_buttons = $"СolorSchemeButtons"
@onready var start_scheme_button = $"СolorSchemeButtons/ColorSchemeButton"
var color_scheme_button_scene = "res://Scenes/color_scheme_button.tscn"
var popup
var scheme_array = [2, 3, 3, 3, 4, 4]

func _ready() -> void:
	popup = scheme_menu_button.get_popup()
	popup.id_pressed.connect(on_id_pressed)
	if popup.item_count > 0:
		# Установка текста для первого элемента
		scheme_menu_button.text = popup.get_item_text(0)
		# Имитируем нажатие на первый элемент для загрузки начальных кнопок
		on_id_pressed(0)
		
	set_new_bg_color(start_scheme_button, Color(1, 1, 1))
	
func on_id_pressed(id):
	# Обновляем текст кнопки
	scheme_menu_button.text = popup.get_item_text(id)
	
	# Очищаем все дочерние элементы из color_scheme_buttons, кроме первого
	clear_color_scheme_buttons()
	
	# Создаем новые кнопки в зависимости от значения в scheme_array
	if id < scheme_array.size():
		var buttons_count = scheme_array[id]
		# Добавляем на одну кнопку меньше
		if buttons_count > 0:
			add_color_scheme_buttons(buttons_count - 1)

# Функция для очистки всех дочерних элементов из color_scheme_buttons, кроме первого
func clear_color_scheme_buttons():
	# Пропускаем первый элемент и удаляем остальные
	for i in range(color_scheme_buttons.get_child_count() - 1, 0, -1):
		var child = color_scheme_buttons.get_child(i)
		color_scheme_buttons.remove_child(child)
		child.queue_free()

# Функция для добавления нового количества кнопок
func add_color_scheme_buttons(count: int):
	for i in range(count):
		var button_instance = load(color_scheme_button_scene).instantiate()
		button_instance.disabled = true
		color_scheme_buttons.add_child(button_instance)

#func _on_color_scheme_color_picker_color_changed(color: Color) -> void:
	#pass
	#
func set_new_bg_color(button: ColorSchemeButton, color:Color)-> void:
	var normal_bg_color = StyleBoxFlat.new()
	normal_bg_color.bg_color = color
	button.add_theme_stylebox_override("normal", normal_bg_color)
