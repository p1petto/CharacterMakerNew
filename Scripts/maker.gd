extends Node2D

@onready var subviewport = $SubViewportContainer/SubViewport
#@onready var UI = $Camera2D/UI
@onready var camera = $Camera2D
@onready var character_texture = $UI/CharacterShow
@onready var direction_controller = $UI/DirectionButtons
@onready var position_controller = $UI/PositionController


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	character_texture.scale.x = Global.scaling
	character_texture.scale.y = Global.scaling

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		var screen = subviewport.get_texture().get_image()
		screen.save_png("screenshot.png")
		
