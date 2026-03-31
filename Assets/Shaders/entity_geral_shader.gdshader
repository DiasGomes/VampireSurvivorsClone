shader_type canvas_item;

// Outline effect
uniform vec4 outline_color : source_color = vec4(1.0);
uniform float width : hint_range(0, 10) = 1.0;
uniform int pattern : hint_range(0, 2) = 0; // diamond, circle, square
uniform bool active_outline = false; 
// Blink effect
uniform vec4 blink_color: source_color;
uniform float blink_intesity = 0.0;

vec4 apply_outline(vec2 uv, vec2 texture_pixel_size, sampler2D _texture, vec4 _color) {
	if (_color.a > 0.0) {return _color;}

    float w = ceil(width);

    for (float i = -w; i <= w; i++) {

        float x = clamp(i, -width, width);
        float offset;

        if (pattern == 0) {
            offset = width - abs(x);
        } else if (pattern == 1) {
            float r = width + 0.5;
            offset = floor(sqrt(r * r - x * x));
        } else {
            offset = width;
        }

        for (float j = -offset; j <= offset; j++) {

            float y = clamp(j, -offset, offset);
            vec2 xy = uv + texture_pixel_size * vec2(x, y);

            bool outside_texture =
                xy.x < 0.0 || xy.x > 1.0 ||
                xy.y < 0.0 || xy.y > 1.0;

            if (!outside_texture && texture(_texture, xy).a > 0.0) {
                _color.rgb = outline_color.rgb;
                _color.a = outline_color.a;
                return _color;
            }
        }
    }
    return _color;
}

vec4 apply_blink(sampler2D _texture, vec2 _uv) {
	vec4 b_color = texture(_texture, _uv);
	b_color = mix(b_color, blink_color, blink_intesity * b_color.a);

	return b_color;
}

void fragment() {
	COLOR = apply_blink(TEXTURE, UV);
	if(active_outline){
		COLOR = apply_outline(UV, TEXTURE_PIXEL_SIZE, TEXTURE, COLOR);
	}
}