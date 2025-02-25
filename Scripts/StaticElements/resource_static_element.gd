extends Resource

class_name Static

@export var sprite_frames: SpriteFrames
@export var position: Vector2
@export_enum("Body", "Head") 
var target_part: String = "Body"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
