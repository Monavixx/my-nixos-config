#version 300 es
precision highp float;

in vec2 v_texcoord;
uniform sampler2D tex;
out vec4 fragColor;

// Adjust these to taste.
const float WARMTH = 0.35; // 0 = neutral, 1 = full warm tint
const float DIMMING = 0.12; // 0 = unchanged brightness, 1 = black

void main() {
    vec3 color = texture(tex, v_texcoord).rgb;
    vec3 warmTint = mix(vec3(1.0), vec3(1.0, 0.82, 0.55), WARMTH);

    color *= warmTint * (1.0 - DIMMING);

    fragColor = vec4(color, 1.0);
}
