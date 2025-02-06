extends Node2D

@onready var animated_sprite = $AnimatedSprite2D

@export var sprite_frames: SpriteFrames
@export var flip_x = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if sprite_frames:
		animated_sprite.sprite_frames = sprite_frames
	if flip_x:
		animated_sprite.flip_h = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
