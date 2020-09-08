shader_type canvas_item;

uniform float amount : hint_range(0, 1);
uniform sampler2D noise_texture;

void fragment(){	
	vec4 noise_pixel_color = texture(noise_texture, UV);
	
	float noise_color = 1.0 - noise_pixel_color.r;
	
	float alpha = smoothstep(0.0, noise_color, amount);
	
	COLOR = vec4(0.0, 0.0, 0.0, alpha);

}