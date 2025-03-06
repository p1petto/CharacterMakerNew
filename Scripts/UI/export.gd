extends Button

@onready var animation_player_button = $"../AnimationPlayer"
@onready var dir_down_button = $"../../DirectionButtons/Down"
@onready var character = $"../../../SubViewportContainer/SubViewport/Character"
@onready var animation_controller = $"../../../AnimationController"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_up() -> void:
	animation_controller.clear_all_states()
