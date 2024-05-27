shader_type spatial;

uniform sampler2D water_texture;

uniform sampler2D amplitude_map;
uniform float max_freq = 1.0;
uniform sampler2D phase_map;
uniform sampler2D dir_map_x;
uniform sampler2D dir_map_z;
uniform sampler2D speed_map;

vec2 wave_height(float p, float a, float f, float phase, float speed) {
	float h = a * sin(p * f + phase + TIME * speed);
	float d = a * f * cos(p * f + phase + TIME * speed);
	return vec2(h,d);
}

void vertex() {
	
	NORMAL = vec3(0,1,0);
	vec2 hd = vec2(0.);
	
	for(int i = 0; i < 32; ++i) {
		ivec2 texel = ivec2(i, 0);
		
		vec2 dir = normalize(vec2(texelFetch(dir_map_x, texel, 0).r * 2.0 - 1.0, texelFetch(dir_map_z, texel, 0).r) * 2.0 - 1.0);
		float amp = texelFetch(amplitude_map, texel, 0).r;
		float freq = float(i) / 31. * max_freq;
		float phase = texelFetch(phase_map, texel, 0).r;
		float speed = texelFetch(speed_map, texel, 0).r;
		
		vec2 hd = wave_height(dot(VERTEX.xz, dir), amp, freq, phase, speed);
		
		VERTEX.y += hd.x;
		NORMAL.x -= dir.x * hd.y;
		NORMAL.z -= dir.y * hd.y;
		
	}
	NORMAL = normalize(NORMAL);
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec4 col = texture(water_texture, UV + vec2(TIME * 0.02));
	ALBEDO = col.rgb;
	ALPHA = col.a;
}

void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
	DIFFUSE_LIGHT += dot(LIGHT, NORMAL) * LIGHT_COLOR;
	float thing = pow(1. - dot(VIEW + LIGHT, NORMAL), 5.);
	SPECULAR_LIGHT += thing * LIGHT_COLOR;
}
