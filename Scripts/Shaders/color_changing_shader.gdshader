shader_type canvas_item;

// Основной цвет, который будет использоваться для интерполяции
uniform vec4 cur_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
// Коэффициент интерполяции (0.0 = оригинальный цвет, 1.0 = новый цвет)
uniform float blend_factor : hint_range(0.0, 1.0) = 0.6;

void fragment() {
	// Получаем оригинальный цвет из текстуры
	vec4 original_color = texture(TEXTURE, UV);

	// Интерполируем между оригинальным цветом и новым цветом
	vec3 blended_rgb;
	blended_rgb.r = (original_color.r - cur_color.r) * (1.0 - blend_factor) + cur_color.r;
	blended_rgb.g = (original_color.g - cur_color.g) * (1.0 - blend_factor) + cur_color.g;
	blended_rgb.b = (original_color.b - cur_color.b) * (1.0 - blend_factor) + cur_color.b;

	// Сохраняем оригинальный альфа-канал
	COLOR = vec4(blended_rgb, original_color.a);
}