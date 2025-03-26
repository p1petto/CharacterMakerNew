shader_type canvas_item;

uniform float radius : hint_range(0.0, 1.0) = 0.5;
uniform float border_width : hint_range(0.0, 0.5) = 0.0;
uniform vec4 border_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform vec4 newcolor : source_color;

void fragment() {
    vec2 uv = UV - 0.5;
    float aspect_ratio = TEXTURE_PIXEL_SIZE.y / TEXTURE_PIXEL_SIZE.x;
    uv.x *= aspect_ratio;
    float dist = length(uv);
    vec4 base_color = texture(TEXTURE, UV) * COLOR;
    
    // Если расстояние меньше радиуса - это внутренняя часть круга
    if (dist < radius - border_width) {
        COLOR = base_color;
    }
    // Если расстояние между радиусом и радиусом+толщина_границы - это граница
    else if (dist < radius) {
        COLOR = border_color;
    }
    // В противном случае - это фон (прозрачный)
    else {
        COLOR = vec4(0.0, 0.0, 0.0, 0.0);
    }
}
