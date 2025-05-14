shader_type canvas_item;
uniform float radius : hint_range(0.0, 1.0) = 0.5;
uniform float border_width : hint_range(0.0, 0.5) = 0.0;
uniform vec4 border_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform vec4 newcolor : source_color;
uniform bool is_flooded_inside = true;

void fragment() {
    vec2 uv = UV - 0.5;
    float aspect_ratio = TEXTURE_PIXEL_SIZE.y / TEXTURE_PIXEL_SIZE.x;
    uv.x *= aspect_ratio;
    float dist = length(uv);
    vec4 base_color = texture(TEXTURE, UV) * COLOR;

    if (is_flooded_inside) {
		// Внутренняя часть круга закрашена
        if (dist < radius - border_width) {
            COLOR = base_color;
        }
        // Если расстояние между радиусом и радиусом+толщина_границы - это граница
        else if (dist < radius) {
            COLOR = border_color;
        }
        // Иначе - это фон (прозрачный)
        else {
            COLOR = vec4(0.0, 0.0, 0.0, 0.0);
        }
    } else {
        // Внешняя часть круга закрашена
        if (dist > radius) {
            COLOR = base_color;
        }
        // Если расстояние между радиусом и радиусом-толщина_границы - это граница
        else if (dist > radius - border_width) {
            COLOR = border_color;
        }
        // Иначе - это круг (прозрачный)
        else {
            COLOR = vec4(0.0, 0.0, 0.0, 0.0);
        }
    }
}