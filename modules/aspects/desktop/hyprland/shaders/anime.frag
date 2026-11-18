
#version 300 es

precision highp float;
precision highp int;

in vec2 v_texcoord;
layout(location = 0) out vec4 fragColor;

uniform sampler2D tex;

// Pseudo-random hash
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}

// Safe texture sampling
vec3 sampleScreen(vec2 uv) {
    return texture(tex, clamp(uv, vec2(0.0), vec2(1.0))).rgb;
}

// Detect high-detail regions (text)
float textDetect(vec2 uv, vec2 px) {
    vec3 W = vec3(0.299, 0.587, 0.114);

    float c = dot(sampleScreen(uv), W);
    float e = 0.0;

    e += abs(c - dot(sampleScreen(uv + vec2(-px.x, 0.0)), W));
    e += abs(c - dot(sampleScreen(uv + vec2( px.x, 0.0)), W));
    e += abs(c - dot(sampleScreen(uv + vec2(0.0, -px.y)), W));
    e += abs(c - dot(sampleScreen(uv + vec2(0.0,  px.y)), W));
    e += abs(c - dot(sampleScreen(uv + vec2(-px.x, -px.y)), W));
    e += abs(c - dot(sampleScreen(uv + vec2( px.x,  px.y)), W));

    return smoothstep(0.15, 0.6, e);
}

void main() {
    vec2 uv = v_texcoord;
    vec2 px = 1.0 / vec2(textureSize(tex, 0));

    vec3 orig = sampleScreen(uv);
    vec3 color = vec3(0.0);

    // --- Watercolor bleed ---
    float total = 0.0;

    for (int x = -2; x <= 2; x++) {
        for (int y = -2; y <= 2; y++) {
            vec2 offset = vec2(float(x), float(y)) * px * 1.5;

            float weight = 1.0 / (1.0 + float(x*x + y*y));

            color += sampleScreen(uv + offset) * weight;
            total += weight;
        }
    }

    color /= total;

    // --- Soft cel-shading ---
    float lum = dot(color, vec3(0.2126, 0.7152, 0.0722));

    float shading =
          smoothstep(0.0, 0.35, lum) * 0.33
        + smoothstep(0.35, 0.65, lum) * 0.33
        + smoothstep(0.65, 1.0, lum) * 0.34;

    color *= 0.6 + shading * 0.6;

    // --- Warm Ghibli palette ---
    color = pow(max(color, vec3(0.0)), vec3(0.92, 0.97, 1.08));

    // Warm shadows
    vec3 shadowTint = vec3(0.15, 0.08, 0.12);
    color += shadowTint * (1.0 - lum) * 0.2;

    // Gentle saturation boost
    float qlum = dot(color, vec3(0.2126, 0.7152, 0.0722));
    color = mix(vec3(qlum), color, 1.2);

    // --- Soft edge outlines ---
    vec3 c = orig;
    vec3 r = sampleScreen(uv + vec2(px.x, 0.0));
    vec3 b = sampleScreen(uv + vec2(0.0, px.y));

    float edge = length(c - r) + length(c - b);
    edge = smoothstep(0.08, 0.25, edge);

    color = mix(color, color * 0.4, edge * 0.35);

    // --- Gentle bloom ---
    vec3 bloom = vec3(0.0);

    for (int i = 1; i <= 3; i++) {
        float radius = float(i) * 2.0;

        bloom += sampleScreen(uv + vec2(radius, 0.0) * px);
        bloom += sampleScreen(uv - vec2(radius, 0.0) * px);
        bloom += sampleScreen(uv + vec2(0.0, radius) * px);
        bloom += sampleScreen(uv - vec2(0.0, radius) * px);
    }

    bloom /= 12.0;
    color += (bloom - color) * 0.08;

    // --- Subtle paper grain ---
    float grain = (hash(uv * vec2(textureSize(tex, 0)) * 0.5) - 0.5) * 0.02;
    color += grain;

    // --- Text preservation ---
    float detail = textDetect(uv, px);
    color = mix(color, orig, detail * 0.7);

    fragColor = vec4(clamp(color, 0.0, 1.0), 1.0);
}

