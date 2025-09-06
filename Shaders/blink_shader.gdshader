shader_type canvas_item;

uniform vec4 blink_color : source_color;
uniform float blink_intensity = 0;

void fragment() {
	//Pegando a cor da sprite
	vec4 color = texture(TEXTURE, UV);
	
	//Misturando os dois
	color = mix(color, blink_color, blink_intensity * color.a);
	
	//Atualizando a cor
	COLOR = color;
}
