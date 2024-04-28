shader_type spatial;

uniform sampler2D u_heightmap;
uniform sampler2D u_normalmap;
uniform sampler2D u_texture;

uniform float u_height;

void vertex() {
	//COLOR = vec4(UV,0,1);//texture(u_heightmap, UV);
	VERTEX.y += texture(u_heightmap, UV).r * u_height;
	//float v = texture(u_heightmap, UV).r;
	//float dx = (texture(u_heightmap, UV + vec2(0.001,0)).r - v) * 100.;
	//float dz = (texture(u_heightmap, UV + vec2(0,0.001)).r - v) * 100.;
	//NORMAL = normalize(vec3(-dx, 1., -dz));
	NORMAL = texture(u_normalmap, UV).rgb;
}

void fragment() {
	ALBEDO = vec3(0);
	for(int i = 1; i < 6; ++i) {
		ALBEDO += texture(u_texture, UV * float(i)).rgb;
	}
	ALBEDO /= 5.0;
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
