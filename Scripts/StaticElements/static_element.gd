extends AnimatedSprite2D

class_name StaticElement

@export var static_resource: Static
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite_frames = static_resource.sprite_frames
	position = static_resource.position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
