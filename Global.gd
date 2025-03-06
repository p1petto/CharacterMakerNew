extends Node

var current_dir = "down"
var current_animation = "idle"
var animation_is_run = false
var animation_states = ["idle", "walk"]
var directions = ["down", "right", "top", "left"]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
