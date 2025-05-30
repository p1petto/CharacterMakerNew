extends TextureButton

@export var texture_run_normal: CompressedTexture2D
@export var texture_run_hover: CompressedTexture2D
@export var texture_run_pressed: CompressedTexture2D
@export var texture_stop_normal: CompressedTexture2D
@export var texture_stop_hover: CompressedTexture2D
@export var texture_stop_pressed: CompressedTexture2D

func _ready() -> void:
	change_textures()

func change_textures():
	await get_tree().process_frame
	if Global.animation_is_run:
		texture_normal = texture_stop_normal
		texture_pressed = texture_stop_pressed
		texture_hover = texture_stop_hover
	else:
		texture_normal = texture_run_normal
		texture_pressed = texture_run_pressed
		texture_hover = texture_run_hover

func _on_button_up() -> void:
	change_textures()
