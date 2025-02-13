extends TextureButton

@onready var texture_rect = $CenterContainer/TextureRect

@export var item: CatalogItem

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	texture_rect.texture = item.icon


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
