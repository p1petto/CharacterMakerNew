extends Node2D

@onready var subviewport = $SubViewportContainer/SubViewport

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		var screen = subviewport.get_texture().get_image()
		screen.save_png("screenshot.png")
