extends ColorRect

@onready var catallog = $"../Catalog"
@onready var character = $"../../SubViewportContainer/SubViewport/Character"

var cur_element

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in get_children():
		child.change_position.connect(_on_position_changed)
		
	catallog.tab_changed.connect(_on_tab_changed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_position_changed(val):
	cur_element = character.find_child(catallog.current_tab.name, true, false)
	
	if !cur_element:
		print("Ошибка: не найден cur_element")
		return
	
	# Если элемент не симметричен, двигаем только его
	if !cur_element.is_symmetrical:
		if cur_element.static_resource.cur_position == Vector2.ZERO:
			cur_element.static_resource.cur_position = cur_element.static_resource.start_position
		
		var new_position = cur_element.static_resource.cur_position + val
		
		# Ограничиваем по границам
		new_position.x = clamp(new_position.x, cur_element.static_resource.min_x, cur_element.static_resource.max_x)
		new_position.y = clamp(new_position.y, cur_element.static_resource.min_y, cur_element.static_resource.max_y)
		
		# Обновляем позицию
		cur_element.static_resource.cur_position = new_position
		cur_element.position = new_position
	else:
		# Ищем связанную симметричную ноду
		var cur_linked_element = character.find_child(catallog.current_tab.linked_symmetrical_element.name, true, false)
		
		if !cur_linked_element:
			print("Ошибка: не найден cur_linked_element")
			return
		
		# Определяем направление изменения позиции
		var linked_val = val
		
		# Инвертируем X для элемента и его симметричного элемента, если имя начинается с "Right"
		if cur_element.name.begins_with("Right"):
			linked_val.x = -val.x  # Инвертируем X для cur_element
		
		if cur_linked_element.name.begins_with("Right"):
			linked_val.x = -linked_val.x  # Инвертируем X для симметричного элемента

		# Проверяем и обновляем позицию для обоих элементов
		for element in [cur_element, cur_linked_element]:
			if element.static_resource.cur_position == Vector2.ZERO:
				element.static_resource.cur_position = element.static_resource.start_position
			
			var new_pos = element.static_resource.cur_position + (linked_val if element == cur_linked_element else val)
			
			# У симметричного элемента Y должен быть таким же, как у основного элемента
			if element == cur_linked_element:
				new_pos.y = cur_element.static_resource.cur_position.y  # Присваиваем Y от основного элемента
			
			# Ограничиваем по границам
			new_pos.x = clamp(new_pos.x, element.static_resource.min_x, element.static_resource.max_x)
			new_pos.y = clamp(new_pos.y, element.static_resource.min_y, element.static_resource.max_y)
			
			# Обновляем позицию
			element.static_resource.cur_position = new_pos
			element.position = new_pos
			# Если симметрия включена, установим начальную позицию симметричного элемента на зеркальную относительно основного
			if element == cur_linked_element and cur_element.is_symmetrical:
				# Зеркалим позицию относительно start_position
				element.static_resource.cur_position.x = cur_element.static_resource.start_position.x - (cur_element.static_resource.cur_position.x - cur_element.static_resource.start_position.x)
				# После этого обновляем позицию симметричного элемента
				element.position = element.static_resource.cur_position



		
	
func _on_tab_changed():
	visible = catallog.current_tab.is_in_group("StaticTab")

		
