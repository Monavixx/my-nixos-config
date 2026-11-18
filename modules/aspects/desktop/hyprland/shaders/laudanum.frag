#version 300 es
precision highp float;

in vec2 v_texcoord;
uniform sampler2D tex;
out vec4 fragColor;

// ------------- Tweakables -------------
const float PALLOR     = 0.50;  // drain color toward bone-white (0 = off, 1 = monochrome)
const float BLOOD      = 0.55;  // crimson tint in shadows
const float AMBER      = 0.35;  // candlelight tint in highlights
const float BLACK_LIFT = 0.06;  // lifts pure black into deep wine (0 = true black)
const float SMOKE      = 0.30;  // crimson/plum haze in dark areas (0 = off)
const float SMOKE_SCALE = 2.2;  // bigger = smaller, busier smoke
const float VIGNETTE   = 0.60;  // blood-dark edges
const float CONTRAST   = 1.08;
const float GRAIN      = 0.025; // film grain, applied mostly to darks
// --------------------------------------

const vec3 LUMA = vec3(0.2126, 0.7152, 0.0722);

float hash(vec2 p) {
    vec3 p3 = fract(vec3(p.xyx) * 0.1031);
    p3 += dot(p3, p3.yzx + 33.33);
    return fract((p3.x + p3.y) * p3.z);
}

float vnoise(vec2 p) {
    vec2 i = floor(p), f = fract(p);
    f = f * f * (3.0 - 2.0 * f);
    return mix(mix(hash(i),              hash(i + vec2(1, 0)), f.x),
               mix(hash(i + vec2(0, 1)), hash(i + vec2(1, 1)), f.x), f.y);
}

float fbm(vec2 p) {
    return 0.55 * vnoise(p) + 0.30 * vnoise(p * 2.03 + 7.3) + 0.15 * vnoise(p * 4.1 + 13.1);
}

// Re-tint c so it has luminance l (keeps text contrast intact)
vec3 withLuma(vec3 c, float l) {
    return c * (l / max(dot(c, LUMA), 1e-4));
}

void main() {
    vec2 uv  = v_texcoord;
    vec2 d   = uv - 0.5;
    vec3 src = texture(tex, uv).rgb;          // single exact sample: no blur
    float lum = dot(src, LUMA);

    // --- Pallor: drain the color ---
    vec3 col = mix(src, vec3(lum), PALLOR);

    // --- Split-tone: oxblood shadows, amber highlights, brightness preserved ---
    vec3 wine  = vec3(0.60, 0.04, 0.14);
    vec3 amber = vec3(1.00, 0.72, 0.38);
    float wShadow = 1.0 - smoothstep(0.0, 0.45, lum);
    float wHigh   = smoothstep(0.60, 1.0, lum);
    col = mix(col, withLuma(wine,  lum), BLOOD * wShadow);
    col = mix(col, withLuma(amber, lum), AMBER * wHigh);

    // --- Contrast ---
    col = (col - 0.5) * CONTRAST + 0.5;

    // --- Smoke: static, domain-warped haze that only lives in dark areas ---
    vec2 p = uv * vec2(SMOKE_SCALE * 1.78, SMOKE_SCALE);
    float n = fbm(p + 1.8 * fbm(p * 1.3 + 4.0));
    n = smoothstep(0.30, 0.80, n);
    float darkMask = 1.0 - smoothstep(0.05, 0.50, lum);       // bright text untouched
    float edge = 0.6 + 1.0 * length(d);                       // thicker toward the edges
    vec3 smokeCol = vec3(0.55, 0.06, 0.22);                   // crimson-plum
    col += smokeCol * n * darkMask * edge * SMOKE * 0.20;

    // --- Lift blacks into deep wine ---
    col += BLACK_LIFT * vec3(0.55, 0.05, 0.12) * (1.0 - lum);

    // --- Vignette: edges sink into blood-dark ---
    float r2  = dot(d, d) * 2.0;
    float vig = smoothstep(0.25, 1.15, r2);
    col = mix(col, col * vec3(0.35, 0.12, 0.16), VIGNETTE * vig);

    // --- Grain: static, weighted toward darks so bright text stays clean ---
    float g = hash(gl_FragCoord.xy) - 0.5;
    col += g * GRAIN * (0.4 + 0.6 * (1.0 - lum));

    fragColor = vec4(clamp(col, 0.0, 1.0), 1.0);
}
