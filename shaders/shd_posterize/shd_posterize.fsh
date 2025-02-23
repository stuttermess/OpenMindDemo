varying vec2 v_vTexcoord;
varying vec4 v_vColour;
uniform float posterization_level;
void main() {
    vec4 base = texture2D(gm_BaseTexture, v_vTexcoord);
    //base.rgb = floor(base.rgb * posterization_level) / posterization_level;
    
    
    float gray = max(base.r, max(base.g, base.b));
    float lower = floor(gray * posterization_level) / posterization_level;
    float upper = ceil(gray * posterization_level) / posterization_level;
    float lower_diff = gray - lower;
    float upper_diff = upper - gray;
    
    float level = (lower_diff <= upper_diff) ? lower : upper;
    float adjustment = level / gray;
    
    base.rgb *= adjustment;
    
    
    gl_FragColor = v_vColour * base;
}