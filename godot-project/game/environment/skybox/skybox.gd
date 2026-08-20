extends WorldEnvironment


@export_category("Sky Presets")
@export var dawn_sky: ProceduralSkyMaterial
@export var day_sky: ProceduralSkyMaterial
@export var evening_sky: ProceduralSkyMaterial
@export var night_sky: ProceduralSkyMaterial


@export_category("Time Settings")
@export_range(0.0, 23.99, 0.1)
var dawn_time: float = 5.75
@export_range(0.0, 23.99, 0.1)
var evening_time: float = 20.75
@export_range(0.1, 12.0, 0.1)
var transition_hours: float = 1.0

@export_category("Sun")
@export var sun: DirectionalLight3D
@export_range(-180.0, 180.0, 1.0)
var sun_angle_offset: float = -90.0
@export var max_sun_energy: float = 1.0
@export var sunrise_sun_color := Color(1.0, 0.65, 0.4)
@export var midday_sun_color := Color(1.0, 0.95, 0.85)
@export var sunset_sun_color := Color(1.0, 0.5, 0.3)

@export_category("Moon")
@export var moon: DirectionalLight3D
@export var max_moon_energy: float = 0.15
@export var moon_color := Color(0.65, 0.75, 1.0)

@export_category("Ambient Lighting")
@export var dawn_ambient_color: Color = Color.WHITE
@export var day_ambient_color: Color = Color.WHITE
@export var evening_ambient_color: Color = Color.WHITE
@export var night_ambient_color: Color = Color.WHITE
@export var dawn_ambient_energy: float = 0.5
@export var day_ambient_energy: float = 1.0
@export var evening_ambient_energy: float = 0.5
@export var night_ambient_energy: float = 0.1

func _ready():
	setup_runtime_environment()
	update_environment()


func _process(_delta):
	update_environment()
	update_sun()
	update_moon()
	update_ambient_lighting()

func setup_runtime_environment():
	if environment == null:
		environment = Environment.new()
	else:
		environment = environment.duplicate(true)

	if environment.sky == null:
		environment.sky = Sky.new()
	else:
		environment.sky = environment.sky.duplicate(true)

	if environment.sky.sky_material is ProceduralSkyMaterial:
		environment.sky.sky_material = (
			environment.sky.sky_material.duplicate(true)
		)
	else:
		environment.sky.sky_material = ProceduralSkyMaterial.new()

func update_environment():
	var current_time: float = (
		GameTimeManager.hour +
		(GameTimeManager.minute / 60.0)
	)

	var dawn_start: float = dawn_time - transition_hours
	var dawn_end: float = dawn_time + transition_hours

	var evening_start: float = evening_time - transition_hours
	var evening_end: float = evening_time + transition_hours


	# ----------------------------------------
	# Night → Dawn
	# ----------------------------------------

	if current_time >= dawn_start and current_time < dawn_time:
		var amount: float = inverse_lerp(
			dawn_start,
			dawn_time,
			current_time
		)

		amount = smoothstep(0.0, 1.0, amount)

		interpolate_sky(
			night_sky,
			dawn_sky,
			amount
		)


	# ----------------------------------------
	# Dawn → Day
	# ----------------------------------------

	elif current_time >= dawn_time and current_time < dawn_end:
		var amount: float = inverse_lerp(
			dawn_time,
			dawn_end,
			current_time
		)

		amount = smoothstep(0.0, 1.0, amount)

		interpolate_sky(
			dawn_sky,
			day_sky,
			amount
		)


	# ----------------------------------------
	# Day
	# ----------------------------------------

	elif current_time >= dawn_end and current_time < evening_start:
		apply_sky(day_sky)


	# ----------------------------------------
	# Day → Evening
	# ----------------------------------------

	elif current_time >= evening_start and current_time < evening_time:
		var amount: float = inverse_lerp(
			evening_start,
			evening_time,
			current_time
		)

		amount = smoothstep(0.0, 1.0, amount)

		interpolate_sky(
			day_sky,
			evening_sky,
			amount
		)


	# ----------------------------------------
	# Evening → Night
	# ----------------------------------------

	elif current_time >= evening_time and current_time < evening_end:
		var amount: float = inverse_lerp(
			evening_time,
			evening_end,
			current_time
		)

		amount = smoothstep(0.0, 1.0, amount)

		interpolate_sky(
			evening_sky,
			night_sky,
			amount
		)


	# ----------------------------------------
	# Night
	# ----------------------------------------

	else:
		apply_sky(night_sky)

func update_sun():
	if sun == null:
		return
	
	var current_time: float = (
		GameTimeManager.hour +
		(GameTimeManager.minute / 60.0)
	)
	
	var sunrise_time: float = (
		dawn_time -
		transition_hours
	)
	
	var sunset_time: float = (
		evening_time +
		transition_hours
	)

	var day_duration: float = (
		sunset_time -
		sunrise_time
	)
	
	var day_progress: float = (
		current_time -
		sunrise_time
	) / day_duration
	
	day_progress = clamp(
		day_progress,
		0.0,
		1.0
	)
	
	# --------------------------------------------------
	# Sun rotation
	# --------------------------------------------------
	
	var sun_angle: float = lerp(
		0.0,
		-180.0,
		day_progress
	)
	
	sun.rotation_degrees.x = sun_angle
	
	# --------------------------------------------------
	# Sun energy
	# --------------------------------------------------
	var sun_energy: float = sin(
		day_progress * PI
	)
	
	sun.light_energy = (
		sun_energy *
		max_sun_energy
	)
	
	# --------------------------------------------------
	# Sun colour
	# --------------------------------------------------
	
	var evening_start: float = (
		evening_time -
		transition_hours
	)
	
	var evening_end: float = (
		evening_time +
		transition_hours
	)
	
	if current_time < evening_start:
		# Normal daytime colour.
		sun.light_color = midday_sun_color
	elif current_time < evening_time:
		# Day → Evening.
		var amount: float = inverse_lerp(
			evening_start,
			evening_time,
			current_time
		)
		
		amount = smoothstep(
			0.0,
			1.0,
			amount
		)
		
		sun.light_color = midday_sun_color.lerp(
			sunset_sun_color,
			amount
		)
	elif current_time < evening_end:
		# Evening → Night.
		sun.light_color = sunset_sun_color
	else:
		# Night.
		sun.light_color = sunset_sun_color

func update_moon():
	if moon == null:
		return
	
	var current_time: float = (
		GameTimeManager.hour +
		(GameTimeManager.minute / 60.0)
	)
	
	var sunrise_time: float = (
		dawn_time -
		transition_hours
	)
	
	var sunset_time: float = (
		evening_time +
		transition_hours
	)
	
	# --------------------------------------------------
	# Moon rotation
	# --------------------------------------------------
	
	var night_duration: float = (
		24.0 -
		sunset_time +
		sunrise_time
	)
	
	var day_duration: float = (
		sunset_time -
		sunrise_time
	)
	
	var moon_angle: float
	
	# ----------------------------------------
	# Night: Moonrise → Moonset
	# ----------------------------------------
	if current_time >= sunset_time or current_time < sunrise_time:
		var night_elapsed: float
		
		if current_time >= sunset_time:
			night_elapsed = (
				current_time -
				sunset_time
			)
		else:
			night_elapsed = (
				24.0 -
				sunset_time +
				current_time
			)
			
		var night_progress: float = (
			night_elapsed /
			night_duration
		)
		
		moon_angle = lerp(
			0.0,
			-180.0,
			night_progress
		)
	# ----------------------------------------
	# Day: Moonset → Moonrise
	# ----------------------------------------
	else:
		
		var day_elapsed: float = (
			current_time -
			sunrise_time
		)
		
		var day_progress: float = (
			day_elapsed /
			day_duration
		)
		
		moon_angle = lerp(
			-180.0,
			-360.0,
			day_progress
		)
		
	moon.rotation_degrees.x = moon_angle
	
	# --------------------------------------------------
	# Moon visibility
	# --------------------------------------------------
	var evening_start: float = (
		evening_time -
		transition_hours
	)
	
	var evening_end: float = (
		evening_time +
		transition_hours
	)
	
	var dawn_start: float = (
		dawn_time -
		transition_hours
	)
	
	var dawn_end: float = (
		dawn_time +
		transition_hours
	)
	
	# Evening → Night
	if current_time >= evening_start and current_time < evening_end:
		var amount: float = inverse_lerp(
			evening_start,
			evening_end,
			current_time
		)
		
		amount = smoothstep(
			0.0,
			1.0,
			amount
		)
		
		moon.light_energy = lerp(
			0.0,
			max_moon_energy,
			amount
		)
	# Night
	elif current_time >= evening_end or current_time < dawn_start:
		moon.light_energy = max_moon_energy
	# Night → Dawn
	elif current_time >= dawn_start and current_time < dawn_end:
		var amount: float = inverse_lerp(
			dawn_start,
			dawn_end,
			current_time
		)
		
		amount = smoothstep(
			0.0,
			1.0,
			amount
		)
		
		moon.light_energy = lerp(
			max_moon_energy,
			0.0,
			amount
		)
	# Day
	else:
		moon.light_energy = 0.0

	# --------------------------------------------------
	# Moon colour
	# --------------------------------------------------
	moon.light_color = moon_color

func update_ambient_lighting():
	var current_time: float = (
		GameTimeManager.hour +
		(GameTimeManager.minute / 60.0)
	)
	
	var dawn_start: float = (
		dawn_time -
		transition_hours
	)
	
	var dawn_end: float = (
		dawn_time +
		transition_hours
	)
	
	var evening_start: float = (
		evening_time -
		transition_hours
	)
	
	var evening_end: float = (
		evening_time +
		transition_hours
	)
	# --------------------------------------------------
	# Night → Dawn
	# --------------------------------------------------
	if current_time >= dawn_start and current_time < dawn_time:
		var amount: float = inverse_lerp(
			dawn_start,
			dawn_time,
			current_time
		)
		
		amount = smoothstep(
			0.0,
			1.0,
			amount
		)
		
		interpolate_ambient_lighting(
			night_ambient_color,
			dawn_ambient_color,
			night_ambient_energy,
			dawn_ambient_energy,
			amount
		)
	# --------------------------------------------------
	# Dawn → Day
	# --------------------------------------------------
	elif current_time >= dawn_time and current_time < dawn_end:
		var amount: float = inverse_lerp(
			dawn_time,
			dawn_end,
			current_time
		)
		
		amount = smoothstep(
			0.0,
			1.0,
			amount
		)
		
		interpolate_ambient_lighting(
			dawn_ambient_color,
			day_ambient_color,
			dawn_ambient_energy,
			day_ambient_energy,
			amount
		)
	# --------------------------------------------------
	# Day
	# --------------------------------------------------
	elif current_time >= dawn_end and current_time < evening_start:
		environment.ambient_light_color = day_ambient_color
		environment.ambient_light_energy = day_ambient_energy
	# --------------------------------------------------
	# Day → Evening
	# --------------------------------------------------
	elif current_time >= evening_start and current_time < evening_time:
		var amount: float = inverse_lerp(
			evening_start,
			evening_time,
			current_time
		)
		
		amount = smoothstep(
			0.0,
			1.0,
			amount
		)
		
		interpolate_ambient_lighting(
			day_ambient_color,
			evening_ambient_color,
			day_ambient_energy,
			evening_ambient_energy,
			amount
		)
	# --------------------------------------------------
	# Evening → Night
	# --------------------------------------------------
	elif current_time >= evening_time and current_time < evening_end:
		var amount: float = inverse_lerp(
			evening_time,
			evening_end,
			current_time
		)
		
		amount = smoothstep(
			0.0,
			1.0,
			amount
		)
		
		interpolate_ambient_lighting(
			evening_ambient_color,
			night_ambient_color,
			evening_ambient_energy,
			night_ambient_energy,
			amount
		)
	# --------------------------------------------------
	# Night
	# --------------------------------------------------
	else:
		environment.ambient_light_color = night_ambient_color
		environment.ambient_light_energy = night_ambient_energy

func interpolate_ambient_lighting(
	from_color: Color,
	to_color: Color,
	from_energy: float,
	to_energy: float,
	amount: float
):
	environment.ambient_light_color = from_color.lerp(
		to_color,
		amount
	)

	environment.ambient_light_energy = lerp(
		from_energy,
		to_energy,
		amount
	)

func get_cyclic_transition_amount(
	start_time: float,
	end_time: float,
	current_time: float
) -> float:

	start_time = wrapf(start_time, 0.0, 24.0)
	end_time = wrapf(end_time, 0.0, 24.0)

	var duration: float
	var elapsed: float

	if end_time > start_time:
		duration = end_time - start_time
		elapsed = current_time - start_time

	else:
		duration = (24.0 - start_time) + end_time

		if current_time >= start_time:
			elapsed = current_time - start_time
		else:
			elapsed = (24.0 - start_time) + current_time

	return smoothstep(
		0.0,
		1.0,
		elapsed / duration
	)

func is_time_between(
	current_time: float,
	start_time: float,
	end_time: float
) -> bool:

	start_time = wrapf(start_time, 0.0, 24.0)
	end_time = wrapf(end_time, 0.0, 24.0)

	if start_time < end_time:
		return (
			current_time >= start_time
			and current_time < end_time
		)

	return (
		current_time >= start_time
		or current_time < end_time
	)

func apply_sky(
	sky: ProceduralSkyMaterial
):
	if sky == null:
		return

	var runtime_sky := (
		environment.sky.sky_material
		as ProceduralSkyMaterial
	)

	runtime_sky.sky_top_color = sky.sky_top_color
	runtime_sky.sky_horizon_color = sky.sky_horizon_color

	runtime_sky.ground_bottom_color = (
		sky.ground_bottom_color
	)

	runtime_sky.ground_horizon_color = (
		sky.ground_horizon_color
	)

	runtime_sky.sky_curve = sky.sky_curve
	runtime_sky.ground_curve = sky.ground_curve

func interpolate_sky(
	from: ProceduralSkyMaterial,
	to: ProceduralSkyMaterial,
	amount: float
):
	if from == null or to == null:
		return

	var runtime_sky := (
		environment.sky.sky_material
		as ProceduralSkyMaterial
	)

	runtime_sky.sky_top_color = (
		from.sky_top_color.lerp(
			to.sky_top_color,
			amount
		)
	)

	runtime_sky.sky_horizon_color = (
		from.sky_horizon_color.lerp(
			to.sky_horizon_color,
			amount
		)
	)

	runtime_sky.ground_bottom_color = (
		from.ground_bottom_color.lerp(
			to.ground_bottom_color,
			amount
		)
	)

	runtime_sky.ground_horizon_color = (
		from.ground_horizon_color.lerp(
			to.ground_horizon_color,
			amount
		)
	)

	runtime_sky.sky_curve = lerp(
		from.sky_curve,
		to.sky_curve,
		amount
	)

	runtime_sky.ground_curve = lerp(
		from.ground_curve,
		to.ground_curve,
		amount
	)

#extends WorldEnvironment
#
#@export var dawn_environment: Environment
#@export var day_environment: Environment
#@export var evening_environment: Environment
#@export var night_environment: Environment
#
#func _ready() -> void:
	#update_environment()
	#GameTimeManager.hour_changed.connect(update_environment)
#
#func update_environment():
	#print("Update the Environment Skybox")
	#if GameTimeManager.hour >= 5 and GameTimeManager.hour < 8:
		#environment = dawn_environment
	#elif GameTimeManager.hour >= 8 and GameTimeManager.hour < 17:
		#environment = day_environment
	#elif GameTimeManager.hour >= 17 and GameTimeManager.hour < 21:
		#environment = evening_environment
	#else:
		#environment = night_environment
