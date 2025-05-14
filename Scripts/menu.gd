extends Node2D
@onready var panel = $CanvasLayer/Panel

var panel_visible = false
var maker_scene = "res://Scenes/maker.tscn"

func _on_texture_button_button_up() -> void:
	panel_visible = !panel_visible
	change_visivle_panel()
	
func change_visivle_panel():
	panel.visible = panel_visible


func _on_start_button_button_up() -> void:
	get_tree().change_scene_to_file(maker_scene)
