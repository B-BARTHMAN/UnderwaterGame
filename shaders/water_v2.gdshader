shader_type spatial;

render_mode diffuse_burley;
render_mode cull_front;

#define WAVE_COUNT 32

uniform sampler2D u_freq_ampl;
uniform float u_max_wavelength;
uniform sampler2D u_direction;
uniform sampler2D u_phase;
uniform sampler2D u_speed;

uniform sampler2D u_water_color;
uniform sampler2D u_water_noise;

uniform sampler2D u_screen : hint_screen_texture;
uniform sampler2D u_depth : source_color, hint_depth_texture;

vec2 choppy_wave(float x, float a, float w, float p, float s) {
	float h = a * exp(sin(w * x + p + TIME * s) - 1.);
	float dx = h * w * cos(w * x + p + s * TIME);
	return vec2(h, dx);
}


void vertex() {
	float displacement = 0.0;
	float dx = 0.0;
	float dz = 0.0;
	
	for(int i = 0; i < WAVE_COUNT; ++i) {
		float wl = float(i+1) * u_max_wavelength / float((WAVE_COUNT));
		float freq = TAU / wl;
		
		ivec2 lookup = ivec2(i, 0);
		
		float amp = texelFetch(u_freq_ampl, lookup, 0).r;
		
		float speed = texelFetch(u_speed, lookup, 0).r;
		float dir = texelFetch(u_direction, lookup, 0).r * TAU;
		float phase = texelFetch(u_phase, lookup, 0).r;
		
		vec2 hd = choppy_wave(dot(VERTEX.xz, vec2(cos(dir), sin(dir))), amp, freq, phase * 200., speed);
		displacement += hd.x;
		dx -= hd.y * cos(dir);
		dz -= hd.y * sin(dir);
	}
	
	VERTEX.y += displacement;
	NORMAL = normalize(vec3(dx, 1, dz));
}
void fragment() {
	
	ALBEDO = vec3(.0, .08, .1);
	ROUGHNESS = clamp(pow(1. - dot(VIEW, NORMAL), 4), 0., 1.);
	METALLIC = .6;
	ALPHA = .9;
	
	vec2 pos = (INV_VIEW_MATRIX * vec4(VERTEX, 1.)).xz;
	
	ALBEDO += texture(u_water_noise, mod(pos + vec2(TIME*.3), 32.) / 32.).rgb * .15;
	
	/*
	vec4 view = INV_PROJECTION_MATRIX * vec4(SCREEN_UV * 2.0 - 1.0, texture(u_depth, SCREEN_UV).x, 1.0);
	float linear_depth = -view.z / view.w;
	
	float water_distance = length(VERTEX);
	float object_depth = max(linear_depth - water_distance, 0.01);
	
	ALBEDO += texture(u_screen, SCREEN_UV).rgb * clamp(2. / object_depth, 0., .1);
	*/
}

void light() {
	DIFFUSE_LIGHT += max(dot(LIGHT, NORMAL), 0.) * ATTENUATION * LIGHT_COLOR;
	
	float scatter = clamp(dot(VIEW, NORMAL) * dot(VIEW, NORMAL), 0., 1.) * .25;
	scatter *= clamp(dot(LIGHT, NORMAL), 0., 1.);
	scatter = clamp(scatter, 0., 1.);
	
	DIFFUSE_LIGHT += texture(u_water_color, vec2(scatter, 0.)).rgb * .1;
	SPECULAR_LIGHT += max(pow(dot(normalize(VIEW + LIGHT), NORMAL), 150), 0.) * LIGHT_COLOR;
}