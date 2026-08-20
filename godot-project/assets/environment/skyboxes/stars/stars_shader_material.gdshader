shader_type spatial;

render_mode unshaded, cull_disabled, depth_draw_never;

uniform float star_density : hint_range(1.0, 100.0) = 80.0;
uniform float star_brightness : hint_range(0.0, 10.0) = 1.5;
uniform float star_alpha : hint_range(0.0, 1.0) = 1.0;


float hash(vec2 p)
{
	return fract(
		sin(
			dot(
				p,
				vec2(127.1, 311.7)
			)
		) * 43758.5453123
	);
}


void fragment()
{
	vec2 grid = UV * star_density;

	vec2 cell = floor(grid);
	vec2 local_uv = fract(grid);

	float random = hash(cell);

	// Generate a random star position within this cell.
	vec2 star_position = vec2(
		hash(cell + 1.23),
		hash(cell + 4.56)
	);

	float distance_to_star = distance(
		local_uv,
		star_position
	);

	float star = 1.0 - smoothstep(
		0.0,
		0.05,
		distance_to_star
	);

	// Only some cells contain stars.
	star *= step(0.5, random);

	// Apply our day/night alpha.
	star *= star_alpha;

	ALBEDO = vec3(1.0);
	EMISSION = vec3(1.0) * star * star_brightness;
	ALPHA = star;
}
