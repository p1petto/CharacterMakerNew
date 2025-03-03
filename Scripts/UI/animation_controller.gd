extends Node2D
@onready var character = $"../SubViewportContainer/SubViewport/Character"

var animation_frame = 0  # To keep track of the current animation frame
@export var animation_speed: float = 1.0  # Controls how fast the animation plays
var animation_timer: float = 0.0  # Accumulates time between frame changes

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
	# Reset animation frame and timer when toggled
	if toggled_on:
		animation_frame = 0
		animation_timer = 0.0

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
				if offset is Vector2:
					child.position += offset
									
				if child.is_in_group("ConditionallyDynamic") :
					child.update_frame(frame_index)
					
				child.cur_frame = frame_index
				
	
	# Увеличиваем счетчик кадров ровно на единицу
	animation_frame += 1
