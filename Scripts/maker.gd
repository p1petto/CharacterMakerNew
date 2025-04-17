extends Node2D

@onready var subviewport = $SubViewportContainer/SubViewport
#@onready var UI = $Camera2D/UI
@onready var camera = $Camera2D
@onready var character_texture = $UI/CharacterShow

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	character_texture.scale.x = Global.scaling
	character_texture.scale.y = Global.scaling
	#get_viewport().connect("size_changed", Callable(self, "_on_viewport_resized"))
	#await get_tree().process_frame
	#_update_positions_character()



func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		var screen = subviewport.get_texture().get_image()
		screen.save_png("screenshot.png")
		

#func _update_positions_character() -> void:
	#character_texture.position.x = get_viewport_rect().size.x / 2 - 32*Global.scaling
