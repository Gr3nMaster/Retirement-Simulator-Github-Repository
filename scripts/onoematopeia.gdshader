shader_type canvas_item;

uniform float randh : hint_range(0, 1);
uniform vec4 target_color_a : source_color;
uniform vec4 target_color_b : source_color;
uniform float tolerance : hint_range(0, 1);
vec3 hsv2rgb(vec3 _c) {
    vec4 _K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 _p = abs(fract(_c.xxx + _K.xyz) * 6.0 - _K.www);
    return _c.z * mix(_K.xxx, clamp(_p - _K.xxx, 0.0, 1.0), _c.y);
}

void fragment() {
	vec4 tex_color = texture(TEXTURE, UV);
	
	float dist_a = distance(tex_color, target_color_a);
	float dist_b = distance(tex_color, target_color_b);
	
	if (dist_a < dist_b) {
		tex_color = vec4(hsv2rgb(vec3(randh, 1, (tex_color.g + tex_color.r + tex_color.b))), tex_color.a);
	}
	else {
		tex_color = vec4(hsv2rgb(vec3(randh - 0.5, 1, (tex_color.g + tex_color.r + tex_color.b))), tex_color.a);
	}
	
	COLOR = tex_color;
	
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
