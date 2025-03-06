extends Button

@onready var animation_player_button = $"../AnimationPlayer"
@onready var dir_down_button = $"../../DirectionButtons/Down"
@onready var character = $"../../../SubViewportContainer/SubViewport/Character"
@onready var animation_controller = $"../../../AnimationController"
@onready var subviewport = $"../../../SubViewportContainer/SubViewport"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_button_up() -> void:
	animation_controller.clear_all_states()
	var image_size = subviewport.get_texture().get_size()
	var rows = len(Global.directions)
	var cols = len(character.get_child(0).get(animation_controller.get_offset_name()))
	var total_width = image_size.x * cols
	var total_height = image_size.y * rows

	for i in len(Global.animation_states):
		Global.current_animation = Global.animation_states[i]
		animation_controller.change_animation()

		var sprite_sheet = Image.create(total_width, total_height, false, Image.FORMAT_RGBA8)

		for j in len(Global.directions):
			Global.current_dir = Global.directions[j]

			# Make sure direction is properly updated in all components
			character.on_direction_changed()
			character.change_dir_for_parts()

			var cur_offset_animation = character.get_child(0).get(animation_controller.get_offset_name())
			for k in len(cur_offset_animation):
				# Update animation frame
				animation_controller.animation_frame = k
				animation_controller.animate_children()

				# Add a small delay to ensure rendering is complete
				await get_tree().process_frame

				var screen = subviewport.get_texture().get_image()
				var x_offset = k * image_size.x
				var y_offset = j * image_size.y
				sprite_sheet.blit_rect(screen, Rect2(Vector2.ZERO, image_size), Vector2(x_offset, y_offset))

		var file_name = "sprite_sheet_" + Global.current_animation + ".png"
		sprite_sheet.save_png(file_name)

	animation_controller.clear_all_states()
