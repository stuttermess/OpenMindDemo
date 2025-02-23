//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;
uniform sampler2D uvmap;
uniform vec2 resolution;
void main()
{
	//convert color channels in uvmap image to uv texture coordinates
	
	//split into cells that are 256x256
	//each cell has a corresponding blue value. there can be 256 cells in total
	//blue value = (cell_x) + cell_y*cells_column_amt
	
	vec2 pixel_coords = v_vTexcoord * resolution;
	vec2 cells_amount = resolution / 255.0;//how many cell spaces there are
	vec2 ceil_cells_amount = ceil(cells_amount);
	
	vec4 uvmap_color = texture2D(uvmap, v_vTexcoord);//get the color on the uvmap to convert to uv coordinates
	
	//use blue channel to determine which cell this is
	/*
	x = blue mod column_amount
	y = floor(blue / column_amount)
	*/
	
	float cell_x = floor(mod(uvmap_color.b*255.0, ceil_cells_amount.x))/255.0;
	float cell_y = floor((uvmap_color.b*255.0)/ceil_cells_amount.x)/255.0;
	vec2 cell_xy = vec2(cell_x, cell_y)*255.0;
	
	//add to uvs_xy based on cell
	vec2 uvs_xy = (uvmap_color.xy + (cell_xy)) / cells_amount;
	
	gl_FragColor = v_vColour * texture2D(gm_BaseTexture, uvs_xy);
}