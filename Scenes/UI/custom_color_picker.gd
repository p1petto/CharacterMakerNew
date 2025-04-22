extends NinePatchRect
@onready var color_picker = $ColorPicker
@onready var color_preview = $ColorPicker/HBoxContainer/MarginContainer/ColorRect
signal color_changed(color: Color)
var picking_color := false

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	set_process_input(true)

func _on_button_button_up() -> void:
	picking_color = true
	print("Color picking activated. Move mouse to preview, click to pick color.")

func _input(event: InputEvent) -> void:
	if not picking_color:
		return
		
	if event is InputEventMouseMotion or (event is InputEventMouseButton and event.pressed):
		var viewport := get_viewport()
		var image: Image = viewport.get_texture().get_image()
		var window_size: Vector2 = viewport.get_visible_rect().size
		var image_size: Vector2 = image.get_size()
		var scale: Vector2 = image_size / window_size
		var mouse_pos: Vector2 = event.position * scale
		
		if image and mouse_pos.x >= 0 and mouse_pos.y >= 0 and mouse_pos.x < image_size.x and mouse_pos.y < image_size.y:
			var pixel_color: Color = image.get_pixelv(mouse_pos)
			color_preview.color = pixel_color
			
			if event is InputEventMouseButton and event.pressed:
				set_color_from_code(pixel_color)
				print("Picked color:", pixel_color)
				picking_color = false

func _on_color_picker_color_changed(color: Color) -> void:
	emit_signal("color_changed", color)

func set_color_from_code(color: Color) -> void:
	color_picker.color = color
	color_preview.color = color
	emit_signal("color_changed", color)
