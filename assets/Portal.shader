shader_type canvas_item;

uniform float uv_scale = 0.5;
uniform vec2 time_scale = vec2(1.0, 1.0);
uniform vec2 offset_scale = vec2(2.0, 2.0);
uniform vec2 amplitude = vec2(0.05, 0.05);

uniform sampler2D mask;

void fragment() {
	vec2 uv = UV;
	 uv = (uv - 0.5) * uv_scale + 0.5;

	vec2 waves_uv_offset;
	waves_uv_offset.x = cos(TIME * time_scale.x + (uv.x + uv.y) * offset_scale.x);
	waves_uv_offset.y = sin(TIME * time_scale.y + (uv.x + uv.y) * offset_scale.y);
	
	vec4 color = texture(TEXTURE, uv + waves_uv_offset * amplitude);
	vec4 vmask = texture(mask, UV);
	color.a = vmask.a;
	
	COLOR = color;
}