extends TextureRect


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not material:
		material = ShaderMaterial.new()
		var shader = load("res://Scripts/Shaders/static_color_changing_shader.gdshader")  # Укажите правильный путь
		material.shader = shader
		self.material = material 
		material.set_shader_parameter("oldcolor", Color(1,1,1))
		
func change_color(new_color: Color) -> void:
	material.set_shader_parameter("newcolor", new_color)
