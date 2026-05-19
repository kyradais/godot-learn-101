shader_type canvas_item;

uniform float strength = 0.02;
uniform float speed = 1.0;

void fragment() {
    vec2 uv = UV;

    // Gelombang horizontal
    uv.y += sin(uv.x * 10.0 + TIME * speed) * strength;

    COLOR = texture(TEXTURE, uv);
}