extends Node2D

@onready var subviewport = $SubViewportContainer/SubViewport
#@onready var UI = $Camera2D/UI
@onready var camera = $Camera2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#UI.size = get_viewport_rect().size
	#UI.global_position.x = camera.global_position.x - (get_viewport_rect().size.x / 2)
	#UI.global_position.y = camera.global_position.y + get_viewport_rect().size.y - UI.size.y
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		var screen = subviewport.get_texture().get_image()
		screen.save_png("screenshot.png")
