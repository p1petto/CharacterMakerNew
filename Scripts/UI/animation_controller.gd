extends Node2D
@onready var character = $"../SubViewportContainer/SubViewport/Character"
@onready var button_container = $"../UI/DirectionButtons"

var animation_frame = 0  # To keep track of the current animation frame
@export var animation_speed: float = 1.0  # Controls how fast the animation plays
var animation_timer: float = 0.0  # Accumulates time between frame changes

func _ready():
	for button in button_container.get_children():
		if button.is_in_group("DirectionButton"):
			button.direction_changed.connect(set_start_position)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.animation_is_run:
		# Accumulate time
		animation_timer += delta * animation_speed
		
		# Check if it's time to update the animation
		if animation_timer >= 1.0:  # Update once per second divided by animation_speed
			animate_children()
			animation_timer = 0.0  # Reset timer after updating

func _on_animation_player_toggled(toggled_on: bool) -> void:
	Global.animation_is_run = toggled_on
	
	animation_frame = 0
	animation_timer = 0.0
	
	set_start_position()
	

func animate_children() -> void:
	if character == null:
		return
	
	# Определяем, какое свойство нужно использовать в зависимости от текущей анимации
	var property_name = ""
	if Global.current_animation == "idle":
		property_name = "idle_ainmation_offset"
	elif Global.current_animation == "walk":
		property_name = "walk_animation_offset"
	else:
		property_name = "idle_ainmation_offset"  # По умолчанию
	if Global.current_dir == "down" or Global.current_dir == "top":
		property_name = property_name + "_vertical"
	else:
		property_name = property_name + "_horizontal"
	
	for child in character.get_children():
		# Проверяем, есть ли у дочернего элемента нужное свойство
		if child.get(property_name) != null:
			var offset_array = child.get(property_name)
			if offset_array is Array and offset_array.size() > 0:
				# Применяем смещение на основе текущего кадра анимации
				var frame_index = animation_frame % offset_array.size()
				var offset = offset_array[frame_index]
				
				
									
				if child.is_in_group("ConditionallyDynamic") :
					child.position += offset
					child.update_frame(frame_index)
				elif child.is_in_group("Dynamic") :
					var start_position
					if Global.current_dir == "down":
						start_position = child.dynamic_part.position_down
					elif Global.current_dir == "top":
						start_position = child.dynamic_part.position_top
					elif Global.current_dir == "right":
						start_position = child.dynamic_part.position_right
					elif Global.current_dir == "left":
						start_position = child.dynamic_part.position_left
					child.position = start_position + offset
				
				child.cur_frame = frame_index
				
	
	# Увеличиваем счетчик кадров ровно на единицу
	animation_frame += 1
	
func set_start_position():
	for child in character.get_children():
		child.cur_frame = 0
		if child.is_in_group("Dynamic"):
			child.setup_polygon(Global.current_dir)
		if child.is_in_group("ConditionallyDynamic"):
			child.animated_sprite.frame = 0
			child.position = child.start_position
