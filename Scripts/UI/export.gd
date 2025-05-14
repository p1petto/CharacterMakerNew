extends TextureButton

@onready var character = $"../../../../SubViewportContainer/SubViewport/Character"
@onready var animation_controller = $"../../../../AnimationController"
@onready var subviewport = $"../../../../SubViewportContainer/SubViewport"
var final_sprite_sheet: Image
var is_web_export: bool = false

func _ready() -> void:
	is_web_export = OS.has_feature("web")
	if is_web_export and not Engine.has_singleton("JavaScriptBridge"):
		push_error("JavaScriptBridge не доступен. Автоматическое сохранение в веб-версии может не работать.")

func _on_button_up() -> void:
	generate_sprite_sheet()

func generate_sprite_sheet() -> void:
	animation_controller.clear_all_states()
	var image_size = subviewport.get_texture().get_size()
	var rows = len(Global.directions)
	
	var animation_widths = []
	var animation_heights = []
	var animation_sprite_sheets = []
	
	for i in len(Global.animation_states):
		Global.current_animation = Global.animation_states[i]
		animation_controller.change_animation()
		var cols = len(character.get_child(0).get(animation_controller.get_offset_name()))
		var anim_width = image_size.x * cols
		var anim_height = image_size.y * rows
		
		animation_widths.append(anim_width)
		animation_heights.append(anim_height)
		
		var sprite_sheet = Image.create(anim_width, anim_height, false, Image.FORMAT_RGBA8)
		
		for j in len(Global.directions):
			Global.current_dir = Global.directions[j]
			character.on_direction_changed()
			character.change_dir_for_parts()
			var cur_offset_animation = character.get_child(0).get(animation_controller.get_offset_name())
			
			for k in len(cur_offset_animation):
				animation_controller.animation_frame = k
				animation_controller.animate_children()
				await get_tree().process_frame
				
				var screen = subviewport.get_texture().get_image()
				var x_offset = k * image_size.x
				var y_offset = j * image_size.y
				
				sprite_sheet.blit_rect(screen, Rect2(Vector2.ZERO, image_size), Vector2(x_offset, y_offset))
		
		animation_sprite_sheets.append(sprite_sheet)
	
	var max_width = 0
	for width in animation_widths:
		max_width = max(max_width, width)
	
	var total_height = 0
	for height in animation_heights:
		total_height += height
	
	final_sprite_sheet = Image.create(max_width, total_height, false, Image.FORMAT_RGBA8)
	
	var current_y_offset = 0
	for i in len(animation_sprite_sheets):
		final_sprite_sheet.blit_rect(animation_sprite_sheets[i], 
			Rect2(0, 0, animation_widths[i], animation_heights[i]), 
			Vector2(0, current_y_offset))
		current_y_offset += animation_heights[i]
	
	if is_web_export:
		save_in_web_browser()
	else:
		show_save_dialog()
	
	animation_controller.clear_all_states()

func show_save_dialog() -> void:
	var file_dialog = FileDialog.new()
	file_dialog.access = FileDialog.ACCESS_FILESYSTEM
	file_dialog.file_mode = FileDialog.FILE_MODE_SAVE_FILE
	file_dialog.add_filter("*.png ; PNG Images")
	file_dialog.title = "Сохранить спрайтшит"
	file_dialog.current_path = "sprite_sheet.png"
	
	file_dialog.connect("file_selected", Callable(self, "_on_file_selected"))
	
	get_tree().root.add_child(file_dialog)
	file_dialog.popup_centered_ratio(0.7)

func _on_file_selected(path: String) -> void:
	final_sprite_sheet.save_png(path)
	print("Спрайтшит сохранен: " + path)

func save_in_web_browser() -> void:
	var buffer = final_sprite_sheet.save_png_to_buffer()
	var base64_str = Marshalls.raw_to_base64(buffer)
	
	var datetime = Time.get_datetime_dict_from_system()
	var file_name = "sprite_sheet_%04d%02d%02d_%02d%02d%02d.png" % [
		datetime["year"], datetime["month"], datetime["day"],
		datetime["hour"], datetime["minute"], datetime["second"]
	]
	
	if OS.has_feature("web"):
		var js_code = """
			var a = document.createElement('a');
			a.href = 'data:image/png;base64,%s';
			a.download = '%s';
			document.body.appendChild(a);
			a.click();
			document.body.removeChild(a);
		""" % [base64_str, file_name]
		
		JavaScriptBridge.eval(js_code)
		
		print("Спрайтшит сохранен в папку загрузок: " + file_name)
	else:
		var temp_path = OS.get_user_data_dir() + "/" + file_name
		final_sprite_sheet.save_png(temp_path)
		print("Спрайтшит сохранен во временную папку: " + temp_path)
