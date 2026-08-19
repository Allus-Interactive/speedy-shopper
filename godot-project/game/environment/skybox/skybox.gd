extends WorldEnvironment

@export_category("Environment Presets")

@export var dawn_environment: Environment
@export var day_environment: Environment
@export var evening_environment: Environment
@export var night_environment: Environment

@export_category("Time Settings")

@export var dawn_start: float = 5.0
@export var day_start: float = 8.0
@export var evening_start: float = 17.0
@export var night_start: float = 21.0


func _ready():
	setup_runtime_environment()
	update_environment()


func _process(_delta):
	update_environment()


func setup_runtime_environment():
	# Duplicate the environment
	environment = day_environment.duplicate(true)

	# Make sure the sky is also independent of the preset.
	if environment.sky:
		environment.sky = environment.sky.duplicate(true)

		if environment.sky.sky_material:
			environment.sky.sky_material = environment.sky.sky_material.duplicate(true)


func update_environment():
	var current_time := GameTimeManager.hour + GameTimeManager.minute / 60.0

	# ------------------------------
	# Dawn → Day
	# ------------------------------

	if current_time >= dawn_start and current_time < day_start:

		var amount := get_transition_amount(
			dawn_start,
			day_start,
			current_time
		)

		interpolate_environment(
			dawn_environment,
			day_environment,
			amount
		)


	# ------------------------------
	# Day
	# ------------------------------

	elif current_time >= day_start and current_time < evening_start:

		interpolate_environment(
			day_environment,
			day_environment,
			0.0
		)


	# ------------------------------
	# Evening → Night
	# ------------------------------

	elif current_time >= evening_start and current_time < night_start:

		var amount := get_transition_amount(
			evening_start,
			night_start,
			current_time
		)

		interpolate_environment(
			evening_environment,
			night_environment,
			amount
		)


	# ------------------------------
	# Night
	# ------------------------------

	else:

		interpolate_environment(
			night_environment,
			night_environment,
			0.0
		)


func get_transition_amount(
	start_time: float,
	end_time: float,
	current_time: float
) -> float:

	var amount := inverse_lerp(
		start_time,
		end_time,
		current_time
	)

	return smoothstep(
		0.0,
		1.0,
		amount
	)


func interpolate_environment(
	from: Environment,
	to: Environment,
	amount: float
):

	# ------------------------------
	# Ambient Light
	# ------------------------------

	environment.ambient_light_energy = lerp(
		from.ambient_light_energy,
		to.ambient_light_energy,
		amount
	)

	environment.ambient_light_color = from.ambient_light_color.lerp(
		to.ambient_light_color,
		amount
	)


	# ------------------------------
	# Background
	# ------------------------------

	environment.background_energy_multiplier = lerp(
		from.background_energy_multiplier,
		to.background_energy_multiplier,
		amount
	)


	# ------------------------------
	# Sky
	# ------------------------------

	if from.sky and to.sky:
		interpolate_sky(
			from.sky,
			to.sky,
			amount
		)


func interpolate_sky(
	from_sky: Sky,
	to_sky: Sky,
	amount: float
):

	if not from_sky.sky_material is ProceduralSkyMaterial:
		return

	if not to_sky.sky_material is ProceduralSkyMaterial:
		return

	if not environment.sky:
		return

	if not environment.sky.sky_material is ProceduralSkyMaterial:
		return

	var from_material := (
		from_sky.sky_material as ProceduralSkyMaterial
	)

	var to_material := (
		to_sky.sky_material as ProceduralSkyMaterial
	)

	var runtime_material := (
		environment.sky.sky_material as ProceduralSkyMaterial
	)


	# ------------------------------
	# Sky Colours
	# ------------------------------

	runtime_material.sky_top_color = (
		from_material.sky_top_color.lerp(
			to_material.sky_top_color,
			amount
		)
	)

	runtime_material.sky_horizon_color = (
		from_material.sky_horizon_color.lerp(
			to_material.sky_horizon_color,
			amount
		)
	)


	# ------------------------------
	# Ground Colours
	# ------------------------------

	runtime_material.ground_bottom_color = (
		from_material.ground_bottom_color.lerp(
			to_material.ground_bottom_color,
			amount
		)
	)

	runtime_material.ground_horizon_color = (
		from_material.ground_horizon_color.lerp(
			to_material.ground_horizon_color,
			amount
		)
	)


	# ------------------------------
	# Sky Curves
	# ------------------------------

	runtime_material.sky_curve = lerp(
		from_material.sky_curve,
		to_material.sky_curve,
		amount
	)

	runtime_material.ground_curve = lerp(
		from_material.ground_curve,
		to_material.ground_curve,
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
