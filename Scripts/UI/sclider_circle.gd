extends TextureButton
@export var normal_texture: CompressedTexture2D
@export var active_texture: CompressedTexture2D
var index: int = 0

func _ready() -> void:
	texture_normal = normal_texture
	
func set_index(idx: int) -> void:
	index = idx
	
func set_active(is_active: bool) -> void:
	if is_active:
		texture_normal = active_texture
	else:
		texture_normal = normal_texture
