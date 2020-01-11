attribute vec4 in_Position;
attribute vec2 in_TextureCoord;

varying vec2 v_vTexcoord;

void main() {
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * in_Position;
    
    v_vTexcoord = in_TextureCoord;
}
//######################_==_YOYO_SHADER_MARKER_==_######################@~varying vec2 v_vTexcoord;

void main()
{
    float amount = texture2D(gm_BaseTexture, v_vTexcoord).z;
    gl_FragColor = vec4(1.0, 0.0, 0.0, amount);
}

