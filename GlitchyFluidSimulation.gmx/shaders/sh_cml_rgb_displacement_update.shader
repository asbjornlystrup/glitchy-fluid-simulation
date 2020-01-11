attribute vec4 in_Position;
attribute vec2 in_TextureCoord;

varying vec2 v_vTexcoord;

void main() {
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * in_Position;
    
    v_vTexcoord = in_TextureCoord;
}
//######################_==_YOYO_SHADER_MARKER_==_######################@~/*
    Based on the research paper "Simple and Fast Fluids" by Martin Guay, Fabrice Colin, and Richard Egli from 2011.
*/

varying vec2 v_vTexcoord;

uniform vec2 texel_size;
vec2 velocity_factor = texel_size * 50.0;

float dt = 0.15, k = 0.2;
float scale = 1.0 / 2.0;
float s = 0.2 / 0.15;
float v = 0.1;

void main() {
    // Get and convert data.
    vec4 center = texture2D(gm_BaseTexture, v_vTexcoord); center.xy -= vec2(128.0 / 255.0); center.xy *= 10.0; center.z *= 3.0;
    vec3 right = texture2D(gm_BaseTexture, mod(v_vTexcoord + vec2(texel_size.x, 0.0), 1.0)).xyz; right.xy -= vec2(128.0 / 255.0); right.xy *= 10.0;
    vec3 left = texture2D(gm_BaseTexture, mod(v_vTexcoord - vec2(texel_size.x, 0.0), 1.0)).xyz; left.xy -= vec2(128.0 / 255.0); left.xy *= 10.0;
    vec3 top = texture2D(gm_BaseTexture, mod(v_vTexcoord - vec2(0.0, texel_size.y), 1.0)).xyz; top.xy -= vec2(128.0 / 255.0); top.xy *= 10.0;
    vec3 bottom = texture2D(gm_BaseTexture, mod(v_vTexcoord + vec2(0.0, texel_size.y), 1.0)).xyz; bottom.xy -= vec2(128.0 / 255.0); bottom.xy *= 10.0;
    
    // Uses numerical approximation to obtain the partial derivatives over the current fragment.
    vec3 du_dx = (right - left) * scale, du_dy = (top - bottom) * scale;
    float u_div = du_dx.x + du_dy.y;
    vec2 Ddx = vec2(du_dx.z, du_dy.z);
    
    center.z -= dt * dot(vec3(Ddx, u_div), center.xyz);
    center.z = clamp(center.z, 0.5, 3.0);
    
    vec2 PdX = s * Ddx;
    vec2 laplacian = vec2(right.x + left.x + top.x + bottom.x, right.y + left.y + top.y + bottom.y) - 4.0 * center.xy;
    vec2 viscosity_force = v * laplacian;
    
    vec2 Was = v_vTexcoord - dt * center.xy * texel_size;
    center.xy = texture2D(gm_BaseTexture, mod(Was, 1.0)).xy;
    
    center.xy += dt * (viscosity_force - PdX + vec2(0.0));
    
    // Convert back to texture.
    center.z /= 3.0;
    right.xy /= 10.0; right.xy += vec2(128.0 / 255.0);
    left.xy /= 10.0; left.xy += vec2(128.0 / 255.0);
    top.xy /= 10.0; top.xy += vec2(128.0 / 255.0);
    bottom.xy /= 10.0; bottom.xy += vec2(128.0 / 255.0);
    gl_FragColor = center;
}

