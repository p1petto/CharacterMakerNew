extends AnimatedSprite2D

class_name StaticElement

@export var static_resource: Static

var current_direction: String = "down"
var is_symmetrical = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite_frames = static_resource.sprite_frames
	position = static_resource.position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func change_direction(direction: String) -> void:
	current_direction = direction
	print ("При повороте ", current_direction)
	update_animation()
	
func update_animation() -> void:
	
	sprite_frames = static_resource.sprite_frames
	var animation_name = current_direction
	
	# Проверяем, существует ли такая анимация
	if sprite_frames.has_animation(animation_name):
		animation = animation_name
	else:
		print("Animation not found: ", animation_name)
