extends TextureButton
@onready var character = $"../../../SubViewportContainer/SubViewport/Character"
@onready var animation_controller = $"../../../AnimationController"
@onready var label = $Label


signal animation_changed

func _ready() -> void:
	label.text = Global.current_animation.to_upper()

func _on_button_up() -> void:
	var current_index = Global.animation_states.find(Global.current_animation)
	Global.current_animation = Global.animation_states[(current_index + 1) % Global.animation_states.size()]
	label.text = Global.current_animation.to_upper()
	animation_changed.emit()
	
