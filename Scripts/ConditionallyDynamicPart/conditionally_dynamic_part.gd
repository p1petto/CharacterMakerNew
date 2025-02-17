extends Node2D

@onready var animated_sprite = $AnimatedSprite2D

@export var conditionally_dynamic: ConditionallyDynamic

@export var cur_frame: int
@export var cur_animation: String

@export var z_down: float
@export var z_right: float
@export var z_top: float
@export var z_left: float

var current_state: String = "idle"
var current_direction: String = "down"
var current_thickness: String = "1"

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

func change_thickness(new_thickness: String) -> void:
	current_thickness = new_thickness
	update_animation()

func update_animation() -> void:
	# Собираем имя анимации из компонентов через underscore
	var animation_name = "_".join([current_state, current_direction, current_thickness])
	
	# Проверяем, существует ли такая анимация
	if animated_sprite.sprite_frames.has_animation(animation_name):
		animated_sprite.animation = animation_name
	else:
		print("Animation not found: ", animation_name)

func _process(delta: float) -> void:
	pass
