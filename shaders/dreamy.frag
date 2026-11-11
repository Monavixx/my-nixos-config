
#version 300 es

precision highp float;
precision highp int;

in vec2 v_texcoord;
layout(location = 0) out vec4 fragColor;

uniform sampler2D tex;

// Detect high-detail regions
float textDetect(vec2 uv, vec2 px) {
    vec3 W = vec3(0.299, 0.587, 0.114);

    float c = dot(texture(tex, uv).rgb, W);
    float e = 0.0;

    e += abs(c - dot(texture(tex, uv + vec2(-px.x, 0.0)).rgb, W));
    e += abs(c - dot(texture(tex, uv + vec2( px.x, 0.0)).rgb, W));
    e += abs(c - dot(texture(tex, uv + vec2(0.0, -px.y)).rgb, W));
    e += abs(c - dot(texture(tex, uv + vec2(0.0,  px.y)).rgb, W));
    e += abs(c - dot(texture(tex, uv + vec2(-px.x, -px.y)).rgb, W));
    e += abs(c - dot(texture(tex, uv + vec2( px.x,  px.y)).rgb, W));

    return smoothstep(0.15, 0.6, e);
}

void main() {
    vec2 uv = v_texcoord;

    // Get actual texture dimensions
    vec2 px = 1.0 / vec2(textureSize(tex, 0));

    vec3 orig = texture(tex, uv).rgb;
    vec3 color = orig;

    // --- Bloom ---
    vec3 bloom = vec3(0.0);
    float weights = 0.0;

    for (int x = -2; x <= 2; x++) {
        for (int y = -2; y <= 2; y++) {
            float w = 1.0 / (1.0 + float(x*x + y*y));

            vec2 offset = vec2(float(x), float(y)) * px * 2.5;

            bloom += texture(tex, uv + offset).rgb * w;
            weights += w;
        }
    }

    bloom /= weights;

    color = mix(color, bloom, 0.35);
    color += bloom * 0.15;

    // --- Chromatic aberration ---
    float edgeDist = length(uv - 0.5) * 0.7;
    float ca = edgeDist * 0.003;

    color.r = mix(color.r, texture(tex, uv + vec2(ca, 0.0)).r, 0.4);
    color.b = mix(color.b, texture(tex, uv - vec2(ca, 0.0)).b, 0.4);

    // --- Warm pastel color grade ---
    color = pow(max(color, vec3(0.0)), vec3(0.95, 0.97, 1.05));

    color = color * 0.88 + 0.08;

    color.r = color.r * 1.04 + 0.02;
    color.g = color.g * 1.01;
    color.b = color.b * 0.96 + 0.03;

    float lum = dot(color, vec3(0.2126, 0.7152, 0.0722));
    color = mix(vec3(lum), color, 0.8);

    // --- Static light leak ---
    vec2 leakCenter = vec2(0.85, 0.15);
    float leakDist = length(uv - leakCenter);

    float leak = (1.0 - smoothstep(0.0, 0.7, leakDist)) * 0.12;

    color += vec3(1.0, 0.85, 0.6) * leak;

    // --- Vignette ---
    vec2 vig = uv * (1.0 - uv);

    float vignette = vig.x * vig.y * 15.0;
    vignette = clamp(pow(vignette, 0.4), 0.0, 1.0);

    color *= mix(0.7, 1.0, vignette);

    // --- Preserve text ---
    float detail = textDetect(uv, px);
    color = mix(color, orig, detail * 0.55);

    fragColor = vec4(clamp(color, 0.0, 1.0), 1.0);
}

