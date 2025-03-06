extends Button
@onready var character = $"../../../SubViewportContainer/SubViewport/Character"
@onready var animation_controller = $"../../../AnimationController"


signal animation_changed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text = Global.current_animation

func _on_button_up() -> void:
	var current_index = Global.animation_states.find(Global.current_animation)
	Global.current_animation = Global.animation_states[(current_index + 1) % Global.animation_states.size()]
	text = Global.current_animation
	animation_changed.emit()
	
