extends TextureButton
@onready var panel = $Panel
@onready var label = $Panel/MarginContainer/Label
@export var array_hints: Array[Hint] = []
var current_hint: int = 0
@onready var previous_button = $Panel/previous
@onready var next_button = $Panel/next
@onready var circles_container = $Panel/MarginContainer2/CirclesContainer
var circle_scene = preload("res://Scenes/sclider_circle.tscn")

# Флаг, указывающий, что мышь находится над элементами интерфейса
var is_mouse_over_ui: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Скрываем панель при старте
	panel.visible = false
	initialize()
	
	# Подключаем сигналы наведения мыши на панель
	panel.mouse_entered.connect(_on_ui_mouse_entered)
	panel.mouse_exited.connect(_on_ui_mouse_exited)
	
	# Подключаем сигналы для кнопок навигации
	previous_button.mouse_entered.connect(_on_ui_mouse_entered)
	previous_button.mouse_exited.connect(_on_ui_mouse_exited)
	next_button.mouse_entered.connect(_on_ui_mouse_entered)
	next_button.mouse_exited.connect(_on_ui_mouse_exited)

func change_text() -> void:
	if current_hint >= 0 and current_hint < array_hints.size():
		label.text = array_hints[current_hint].text
		await get_tree().process_frame
		adjust_panel_size()
		
		# Обновляем индикаторы (кружки), выделяя текущий
		update_circles_indicators()
	
func adjust_panel_size() -> void:
	await get_tree().process_frame
	panel.custom_minimum_size.y = label.get_minimum_size().y + 40
	panel.size.y = label.get_minimum_size().y + 34

func next_hint() -> void:
	current_hint = (current_hint + 1) % array_hints.size()
	change_text()

func prev_hint() -> void:
	current_hint = (current_hint - 1 + array_hints.size()) % array_hints.size()
	change_text()

# Исправлены имена функций для сигналов
func _on_next_button_up() -> void:
	next_hint()

func _on_previous_button_up() -> void:
	prev_hint()
	
func initialize():
	
	if array_hints.size() > 0:
		disabled = false
		for child in circles_container.get_children():
			child.queue_free()
		
		if array_hints.size() > 1:
			for i in range(array_hints.size()):
				var circle_instance = circle_scene.instantiate()
				circles_container.add_child(circle_instance)
				
				# Устанавливаем индекс кружка
				if circle_instance.has_method("set_index"):
					circle_instance.set_index(i)
				
				# Подключаем сигнал нажатия на кружок
				circle_instance.pressed.connect(_on_circle_pressed.bind(i))
				
				# Подключаем сигналы наведения мыши на кружок
				circle_instance.mouse_entered.connect(_on_ui_mouse_entered)
				circle_instance.mouse_exited.connect(_on_ui_mouse_exited)
		
		# Обновляем видимость кнопок навигации
		if array_hints.size() > 1:
			previous_button.visible = true
			next_button.visible = true
		else:
			previous_button.visible = false
			next_button.visible = false
		
		# Устанавливаем начальный текст и индикаторы
		current_hint = 0
		change_text()
	else:
		disabled = true

# Функция для обновления индикаторов (выделение текущего кружка)
func update_circles_indicators():
	var circles = circles_container.get_children()
	for i in range(circles.size()):
		var circle = circles[i]
		if circle.has_method("set_active"):
			circle.set_active(i == current_hint)

# Обработчик нажатия на кружок
func _on_circle_pressed(index: int) -> void:
	current_hint = index
	change_text()

# Обработчик наведения мыши на кнопку
func _on_mouse_entered() -> void:
	if not disabled:
		is_mouse_over_ui = true
		update_panel_visibility()

# Обработчик ухода мыши с кнопки
func _on_mouse_exited() -> void:
	if not disabled:
		is_mouse_over_ui = false
		# Используем таймер для небольшой задержки
		get_tree().create_timer(0.05).timeout.connect(update_panel_visibility)

# Универсальный обработчик наведения мыши на любой UI элемент
func _on_ui_mouse_entered() -> void:
	if not disabled:
		is_mouse_over_ui = true
		update_panel_visibility()

# Универсальный обработчик ухода мыши с любого UI элемента
func _on_ui_mouse_exited() -> void:
	if not disabled:
		is_mouse_over_ui = false
		# Используем таймер для небольшой задержки
		get_tree().create_timer(0.05).timeout.connect(update_panel_visibility)

# Обновление видимости панели на основе текущего состояния
func update_panel_visibility() -> void:
	if not disabled:
		panel.visible = is_mouse_over_ui
	else:
		panel.visible = false
