#version 300 es
precision highp float;

in vec2 v_texcoord;
uniform sampler2D tex;
out vec4 fragColor;

// ------------- Tweakables -------------
const float WARMTH     = 0.30;   // 0 = neutral, 1 = very warm (blue-light reduction)
const float VIGNETTE   = 0.30;   // edge darkening strength
const float ABERRATION = 0.0022; // edge color fringing (0 to disable)
const float SATURATION = 1.08;
const float CONTRAST   = 1.04;
const float GRAIN      = 0.020;  // static dither/grain (0 to disable)
// --------------------------------------

float hash(vec2 p) {
    vec3 p3 = fract(vec3(p.xyx) * 0.1031);
    p3 += dot(p3, p3.yzx + 33.33);
    return fract((p3.x + p3.y) * p3.z);
}

void main() {
    vec2 uv = v_texcoord;
    vec2 d  = uv - 0.5;
    float r2 = dot(d, d) * 2.0;          // 0 at center, ~1 in the corners

    // Chromatic aberration grows with r^2, so the center stays sharp
    vec2 off = d * r2 * ABERRATION;
    vec3 col;
    col.r = texture(tex, uv + off).r;
    col.g = texture(tex, uv).g;
    col.b = texture(tex, uv - off).b;

    // Warmth: pull blue down more than green, keep overall brightness similar
    vec3 warm = vec3(1.0, 0.90 - 0.10 * WARMTH, 0.80 - 0.35 * WARMTH);
    vec3 tint = mix(vec3(1.0), warm, WARMTH);
    float lumBefore = dot(col, vec3(0.2126, 0.7152, 0.0722));
    col *= tint;
    float lumAfter = max(dot(col, vec3(0.2126, 0.7152, 0.0722)), 1e-4);
    col *= mix(1.0, lumBefore / lumAfter, 0.5);

    // Saturation + contrast
    float lum = dot(col, vec3(0.2126, 0.7152, 0.0722));
    col = mix(vec3(lum), col, SATURATION);
    col = (col - 0.5) * CONTRAST + 0.5;

    // Soft vignette
    float vig = smoothstep(1.1, 0.35, r2 * 1.1);
    col *= mix(1.0 - VIGNETTE, 1.0, vig);

    // Static grain (also breaks up banding in dark gradients)
    col += (hash(gl_FragCoord.xy) - 0.5) * GRAIN;

    fragColor = vec4(clamp(col, 0.0, 1.0), 1.0);
}
