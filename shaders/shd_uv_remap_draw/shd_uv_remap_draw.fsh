//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;
uniform vec2 resolution;
void main()
{
	//convert uv texture coordinates to color channels for uv map image
	//split into cells that are 256x256
	//each cell has a corresponding blue value. there can be 256 cells in total
	//blue value = (cell_x) + cell_y*cells_column_amt
	
	vec2 pixel_coords = v_vTexcoord * resolution;
	float cells_columns = ceil(resolution.x/256.0);
	vec2 cell = vec2(floor(pixel_coords.x/256.0), floor(pixel_coords.y/256.0));
	
	float r_channel = mod(pixel_coords.x, 256.0)/255.0;
	float g_channel = mod(pixel_coords.y, 256.0)/255.0;
	float b_channel = (cell.x + (cell.y*cells_columns))/255.0;
	
	gl_FragColor = vec4(r_channel, g_channel, b_channel, 1.0);
}