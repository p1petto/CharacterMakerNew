extends AnimatedSprite2D

class_name StaticElement

@export var static_resource: Static

@onready var character = $"../../../"
@onready var catallog = $"../../../../../../UI/Catalog"

var current_direction: String = "down"
var is_symmetrical = false

var color_picker_button
var cur_color: Color
var start_color: Color

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite_frames = static_resource.sprite_frames
	position = static_resource.start_position
	call_deferred("_connect_color_changed_signal")
	call_deferred("_connect_color")
	
	if not material:
		material = ShaderMaterial.new()
		var shader = load("res://Scripts/Shaders/static_color_changing_shader.gdshader")  # Укажите правильный путь
		material.shader = shader
		self.material = material  # Присваиваем материал текущему экземпляру

func _connect_color_changed_signal():
	color_picker_button.color_changed.connect(_on_color_changed)
	
func _connect_color():
	cur_color = static_resource.color
	color_picker_button._on_color_picker_color_changed(cur_color)
	color_picker_button.color_picker.color = cur_color
	start_color = cur_color
	material.set_shader_parameter("oldcolor", cur_color)
	set_start_color()
	
func set_start_color() -> void:
	# Устанавливаем стартовый цвет белым
	cur_color = start_color
	_on_color_changed(cur_color)
	
func _on_color_changed(new_color: Color) -> void:

	#material.set_shader_parameter("oldcolor", cur_color)
	material.set_shader_parameter("newcolor", new_color)
	
	cur_color = new_color
	#modulate = cur_color 
	
	if is_symmetrical:
		var cur_linked_element = character.find_child(catallog.current_tab.linked_symmetrical_element.name, true, false)
		cur_linked_element.material.set_shader_parameter("newcolor", new_color)
		cur_linked_element.cur_color = new_color
		cur_linked_element.color_picker_button.set_new_bg_color(new_color)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func change_direction(direction: String) -> void:
	current_direction = direction
	update_animation()
	
func move_static_element(val):
	if !is_symmetrical:
		if static_resource.cur_position == Vector2.ZERO:
			static_resource.cur_position = static_resource.start_position
		
		var new_position = static_resource.cur_position + val
		
		# Ограничиваем по границам
		new_position.x = clamp(new_position.x, static_resource.min_x, static_resource.max_x)
		new_position.y = clamp(new_position.y, static_resource.min_y, static_resource.max_y)
		
		# Обновляем позицию
		static_resource.cur_position = new_position
		position = new_position
	else:
		# Ищем связанную симметричную ноду
		var cur_linked_element = character.find_child(catallog.current_tab.linked_symmetrical_element.name, true, false)
		
		if !cur_linked_element:
			print("Ошибка: не найден cur_linked_element")
			return
		
		# Определяем направление изменения позиции
		var linked_val = val
		
		# Инвертируем X для элемента и его симметричного элемента, если имя начинается с "Right"
		if name.begins_with("Right"):
			linked_val.x = -val.x  # Инвертируем X для cur_element
		
		if cur_linked_element.name.begins_with("Right"):
			linked_val.x = -linked_val.x  # Инвертируем X для симметричного элемента

		# Проверяем и обновляем позицию для обоих элементов
		for element in [self, cur_linked_element]:
			if element.static_resource.cur_position == Vector2.ZERO:
				element.static_resource.cur_position = element.static_resource.start_position
			
			var new_pos = element.static_resource.cur_position + (linked_val if element == cur_linked_element else val)
			
			# У симметричного элемента Y должен быть таким же, как у основного элемента
			if element == cur_linked_element:
				new_pos.y = static_resource.cur_position.y  # Присваиваем Y от основного элемента
			
			# Ограничиваем по границам
			new_pos.x = clamp(new_pos.x, element.static_resource.min_x, element.static_resource.max_x)
			new_pos.y = clamp(new_pos.y, element.static_resource.min_y, element.static_resource.max_y)
			
			element.static_resource.cur_position = new_pos
			element.position = new_pos
			if element == cur_linked_element and is_symmetrical:
				element.static_resource.cur_position.x = static_resource.start_position.x - (static_resource.cur_position.x - static_resource.start_position.x)
				element.position = element.static_resource.cur_position

	
	
	
func update_animation() -> void:
	
	sprite_frames = static_resource.sprite_frames
	var animation_name = current_direction
	
	# Проверяем, существует ли такая анимация
	if sprite_frames.has_animation(animation_name):
		animation = animation_name
	else:
		print("Animation not found: ", animation_name)
