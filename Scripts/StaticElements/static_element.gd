extends AnimatedSprite2D

class_name StaticElement

@export var static_resource: Static

var current_direction: String = "down"
var is_symmetrical = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite_frames = static_resource.sprite_frames
	position = static_resource.start_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func change_direction(direction: String) -> void:
	current_direction = direction
	update_animation()
	
#func change_position(val: Vector2):
	## Если cur_position ещё не инициализирован, ставим start_position
	#if static_resource.cur_position == Vector2.ZERO:
		#static_resource.cur_position = static_resource.start_position
	#
	#var new_position = static_resource.cur_position + val
	#
	## Ограничиваем по границам
	#new_position.x = clamp(new_position.x, static_resource.min_x, static_resource.max_x)
	#new_position.y = clamp(new_position.y, static_resource.min_y, static_resource.max_y)
	#
	## Обновляем позицию
	#static_resource.cur_position = new_position
	#position = new_position
	
	
	
func update_animation() -> void:
	
	sprite_frames = static_resource.sprite_frames
	var animation_name = current_direction
	
	# Проверяем, существует ли такая анимация
	if sprite_frames.has_animation(animation_name):
		animation = animation_name
	else:
		print("Animation not found: ", animation_name)
