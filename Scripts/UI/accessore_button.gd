extends MarginContainer

@onready var button = $MarginContainer/TextureButton

@export var accessorie: Accessorie

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	button.texture_normal = accessorie.down_texture


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
