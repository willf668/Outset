//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float OffsetX;
uniform float OffsetY;

void main()
{
	vec4 col = v_vColour * texture2D( gm_BaseTexture, v_vTexcoord );
	
	
	vec2 vecR = vec2(v_vTexcoord.x - OffsetX*0.142,  v_vTexcoord.y - OffsetY * 0.0948);
	vec2 vecG = vec2(v_vTexcoord.x + OffsetX*0.0943, v_vTexcoord.y - OffsetY * 0.05829);
	vec2 vecB = vec2(v_vTexcoord.x - OffsetX*0.042,  v_vTexcoord.y + OffsetY * 0.0624);
	
		vecR.x = clamp(vecR.x,0.0, 1.0);
		vecR.y = clamp(vecR.y,0.0, 1.0);
		
		vecG.x = clamp(vecG.x,0.0, 1.0);
		vecG.y = clamp(vecG.y,0.0, 1.0);
		
		vecB.x = clamp(vecB.x,0.0, 1.0);
		vecB.y = clamp(vecB.y,0.0, 1.0);
	
	if(col != vec4(0.0)){
		gl_FragColor = vec4(texture2D(gm_BaseTexture, vecR).r, 
							texture2D(gm_BaseTexture, vecG).g, 
							texture2D(gm_BaseTexture, vecB).b, 
							1.0);
	}
	else{
		gl_FragColor = col;	
	}
}
