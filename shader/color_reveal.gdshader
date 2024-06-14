shader_type spatial;

uniform bool enabled = true;
uniform sampler2D mask_texture;
uniform sampler2D sprite_texture : source_color, filter_nearest;

void fragment() {
	float mask_value = texture(mask_texture, UV).r;

	vec4 color = texture(sprite_texture, UV);
	float gray = (color.r + color.g + color.b) / 3.0;
    ALBEDO = vec3(gray);

    if (enabled && mask_value < 1.0) {
        
    }
}
