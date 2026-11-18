#version 300 es
precision highp float;

in vec2 v_texcoord;
uniform sampler2D tex;
uniform float time;
out vec4 fragColor;

// ------------- Tweakables -------------
const float SPLIT_TONE    = 0.30;  // cool shadows / warm highlights (0 = off)
const float AURORA        = 0.35;  // strength of the drifting color bands (0 = off)
const float AURORA_SPEED  = 0.025; // drift speed (0 = frozen, no constant redraws)
const float AURORA_SCALE  = 1.6;   // bigger = smaller, busier bands
const float SATURATION    = 1.06;
const float DITHER        = 1.0;   // 1 = kill gradient banding, 0 = off
// --------------------------------------

const vec3 LUMA = vec3(0.2126, 0.7152, 0.0722);

float hash(vec2 p) {
    vec3 p3 = fract(vec3(p.xyx) * 0.1031);
    p3 += dot(p3, p3.yzx + 33.33);
    return fract((p3.x + p3.y) * p3.z);
}

// Smooth value noise
float vnoise(vec2 p) {
    vec2 i = floor(p), f = fract(p);
    f = f * f * (3.0 - 2.0 * f);
    return mix(mix(hash(i),               hash(i + vec2(1, 0)), f.x),
               mix(hash(i + vec2(0, 1)),  hash(i + vec2(1, 1)), f.x), f.y);
}

float fbm(vec2 p) {
    return 0.6 * vnoise(p) + 0.3 * vnoise(p * 2.1 + 7.3) + 0.1 * vnoise(p * 4.3 + 13.1);
}

// Cosine palette: smooth teal -> violet -> magenta -> amber cycle
vec3 palette(float t) {
    return 0.5 + 0.5 * cos(6.28318 * (vec3(1.0, 1.0, 1.0) * t + vec3(0.55, 0.15, 0.30)));
}

// Recolor c so it has luminance l (keeps text contrast identical)
vec3 withLuma(vec3 c, float l) {
    return c * (l / max(dot(c, LUMA), 1e-4));
}

void main() {
    vec2 uv  = v_texcoord;
    vec3 src = texture(tex, uv).rgb;      // exact pixel: no blur, no offsets
    float lum = dot(src, LUMA);
    vec3 col = src;

    // --- Split-tone: cool shadows, warm highlights, brightness untouched ---
    vec3 coolTint = vec3(0.45, 0.62, 1.00);
    vec3 warmTint = vec3(1.00, 0.86, 0.70);
    float wShadow = 1.0 - smoothstep(0.05, 0.55, lum);
    float wHigh   = smoothstep(0.55, 1.00, lum);
    col = mix(col, withLuma(coolTint, lum), SPLIT_TONE * wShadow);
    col = mix(col, withLuma(warmTint, lum), SPLIT_TONE * wHigh * 0.6);

    // --- Aurora: slow, drifting color bands that only live in dark areas ---
    float t = time * AURORA_SPEED;
    vec2 p = uv * vec2(AURORA_SCALE * 1.78, AURORA_SCALE);   // roughly square cells
    p += vec2(t * 3.0, t * 1.2);
    float n    = fbm(p + fbm(p + t));                         // domain-warped for a flowing look
    float band = smoothstep(0.35, 0.75, n);                   // some regions stay calm
    vec3 aur   = palette(n * 1.2 + uv.x * 0.35 + t * 2.0);

    float darkMask = 1.0 - smoothstep(0.08, 0.60, lum);       // bright text is left alone
    float edge     = 0.6 + 0.8 * length(uv - 0.5);            // slightly stronger toward edges
    float wAur     = AURORA * band * darkMask * edge;
    col = mix(col, withLuma(aur, lum), clamp(wAur, 0.0, 1.0));

    // --- Gentle saturation, again luminance-safe ---
    float l2 = dot(col, LUMA);
    col = mix(vec3(l2), col, SATURATION);

    // --- Sub-LSB dither: hides banding in the aurora gradients ---
    col += (hash(gl_FragCoord.xy) - 0.5) * (DITHER / 255.0);

    fragColor = vec4(clamp(col, 0.0, 1.0), 1.0);
}
