attribute vec4 in_Position;
attribute vec2 in_TextureCoord;

varying vec2 v_vTexcoord;

void main() {
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * in_Position;
    
    v_vTexcoord = in_TextureCoord;
}
//######################_==_YOYO_SHADER_MARKER_==_######################@~varying vec2 v_vTexcoord;

uniform vec2 texel_size;
uniform vec2 mouse;
uniform vec2 push;

void main() {
    vec4 destination = texture2D(gm_BaseTexture, v_vTexcoord);
    float distance = length((mouse - v_vTexcoord) / texel_size);
    gl_FragColor.z = max(1.0 - distance * 0.035, destination.z);
    gl_FragColor.xy = destination.xy + push * max(1.0 - distance * 0.005, 0.0);
}
