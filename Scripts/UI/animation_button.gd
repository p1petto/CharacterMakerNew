extends Button
@onready var character = $"../../../SubViewportContainer/SubViewport/Character"
var animation_states = ["idle", "walk"]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text = Global.current_animation

func _on_button_up() -> void:
	var current_index = animation_states.find(Global.current_animation)
	Global.current_animation = animation_states[(current_index + 1) % animation_states.size()]
	text = Global.current_animation
	
