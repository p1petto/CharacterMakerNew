extends TextureButton
@onready var panel = $Panel
@onready var label = $Panel/MarginContainer/Label
@export var array_hints: Array[Hint] = []
var current_hint: int = 0
@onready var previous_button = $Panel/previous
@onready var next_button = $Panel/next
@onready var circles_container = $Panel/MarginContainer2/CirclesContainer
var circle_scene = preload("res://Scenes/sclider_circle.tscn")

var is_mouse_over_ui: bool = false

func _ready() -> void:
	panel.visible = false
	initialize()
	
	panel.mouse_entered.connect(_on_ui_mouse_entered)
	panel.mouse_exited.connect(_on_ui_mouse_exited)
	
	previous_button.mouse_entered.connect(_on_ui_mouse_entered)
	previous_button.mouse_exited.connect(_on_ui_mouse_exited)
	next_button.mouse_entered.connect(_on_ui_mouse_entered)
	next_button.mouse_exited.connect(_on_ui_mouse_exited)

func change_text() -> void:
	if current_hint >= 0 and current_hint < array_hints.size():
		label.text = array_hints[current_hint].text
		await get_tree().process_frame
		adjust_panel_size()
		
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
				
				if circle_instance.has_method("set_index"):
					circle_instance.set_index(i)
				
				circle_instance.pressed.connect(_on_circle_pressed.bind(i))
				
				circle_instance.mouse_entered.connect(_on_ui_mouse_entered)
				circle_instance.mouse_exited.connect(_on_ui_mouse_exited)
		
		if array_hints.size() > 1:
			previous_button.visible = true
			next_button.visible = true
		else:
			previous_button.visible = false
			next_button.visible = false
		
		current_hint = 0
		change_text()
	else:
		disabled = true

func update_circles_indicators():
	var circles = circles_container.get_children()
	for i in range(circles.size()):
		var circle = circles[i]
		if circle.has_method("set_active"):
			circle.set_active(i == current_hint)

func _on_circle_pressed(index: int) -> void:
	current_hint = index
	change_text()

func _on_mouse_entered() -> void:
	if not disabled:
		is_mouse_over_ui = true
		update_panel_visibility()

func _on_mouse_exited() -> void:
	if not disabled:
		is_mouse_over_ui = false
		get_tree().create_timer(0.05).timeout.connect(update_panel_visibility)

func _on_ui_mouse_entered() -> void:
	if not disabled:
		is_mouse_over_ui = true
		update_panel_visibility()

func _on_ui_mouse_exited() -> void:
	if not disabled:
		is_mouse_over_ui = false
		get_tree().create_timer(0.05).timeout.connect(update_panel_visibility)

func update_panel_visibility() -> void:
	if not disabled:
		panel.visible = is_mouse_over_ui
	else:
		panel.visible = false
