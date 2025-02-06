extends Node2D

@onready var animated_sprite = $AnimatedSprite2D

@export var sprite_frames: SpriteFrames
@export var flip_x = false
@export var cur_frame:int
@export var cur_animation: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if sprite_frames:
		animated_sprite.sprite_frames = sprite_frames
	if flip_x:
		animated_sprite.flip_h = true
	if cur_animation:
		animated_sprite.animation = cur_animation


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
