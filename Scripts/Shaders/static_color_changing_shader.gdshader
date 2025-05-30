shader_type canvas_item;
uniform vec4 oldcolor : source_color;
uniform vec4 newcolor : source_color;

void fragment() {
	float r = 0.0;
	float g = 0.0;
	float b = 0.0;
    if(distance(COLOR, oldcolor) < 0.5){
        COLOR = newcolor;
		}
}
