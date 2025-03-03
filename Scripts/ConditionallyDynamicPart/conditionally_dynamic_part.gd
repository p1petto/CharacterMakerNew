extends Node2D

class_name ConditionallyDynamicCharacterPart

@onready var animated_sprite = $AnimatedSprite2D

@export var conditionally_dynamic: ConditionallyDynamic

@export var z_down: float
@export var z_right: float
@export var z_top: float
@export var z_left: float

@export var marker_y_pos: int = 0

@export var linked_symmetrical_element: ConditionallyDynamicCharacterPart

@export var cur_animation: String
@export var idle_ainmation_offset: Array[Vector2]
var cur_frame: int

@onready var slider_containers = $"../../../../UI/SliderContainer"

var current_state: String = "idle"
var current_direction: String = "down"
var current_thickness: String = "1"
var is_symmetrical = false

func _ready() -> void:
	if conditionally_dynamic.sprite_frames:
		animated_sprite.sprite_frames = conditionally_dynamic.sprite_frames
	if cur_animation:
		animated_sprite.animation = cur_animation
	else:
		# Установка анимации по умолчанию
		update_animation()

func change_direction(direction: String) -> void:
	if direction not in ["top", "down", "left", "right"]:
		return
		
	match direction:
		"down":
			z_index = z_down
		"right":
			z_index = z_right
		"top":
			z_index = z_top
		"left":
			z_index = z_left
			
	current_direction = direction
	update_animation()

func change_state(new_state: String) -> void:
	current_state = new_state
	update_animation()

func change_thickness(new_thickness) -> void:
	current_thickness = str(new_thickness)
	update_animation()

func update_animation() -> void:
	# Собираем имя анимации из компонентов через underscore
	animated_sprite.sprite_frames = conditionally_dynamic.sprite_frames
	var animation_name = "_".join([current_state, current_direction, current_thickness])
	
	# Проверяем, существует ли такая анимация
	if animated_sprite.sprite_frames.has_animation(animation_name):
		animated_sprite.animation = animation_name
	else:
		print("Animation not found: ", animation_name)

func _process(delta: float) -> void:
	pass
