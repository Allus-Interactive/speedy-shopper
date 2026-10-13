extends VehicleBody3D

class_name Vehicle

@onready var speedometer: TextureRect = $"../CanvasLayer/Speedometer"
@onready var speed_label: Label = $"../CanvasLayer/Speedometer/Speed"
@onready var gears: TextureRect = $"../CanvasLayer/Speedometer/Gears"
# Icons
@onready var sidelights: TextureRect = $"../CanvasLayer/Speedometer/Icons/Sidelights"
@onready var headlights: TextureRect = $"../CanvasLayer/Speedometer/Icons/Headlights"
@onready var full_beam: TextureRect = $"../CanvasLayer/Speedometer/Icons/FullBeam"
@onready var handbrake: TextureRect = $"../CanvasLayer/Speedometer/Icons/Handbrake"

@export var STEER_SPEED = 1.5
@export var STEER_LIMIT = 0.4
var steer_target = 0
@export var engine_force_value = 6500

var gearshift = 3
var gear_multiplicator = 1
var gear_locked = false

var forward_speed : float
var speed: float
var whole_speed: int
const MAX_SPEED: float = 30.0

var is_player_inside = false
var player : Player = null

var is_braking: bool = false

# Lights
enum Lights { OFF, SIDELIGHTS, HEADLIGHTS }
var lights: Lights = Lights.OFF
var is_fullbeam: bool = false
@export var rear_light_material: StandardMaterial3D
@export var front_light_material: StandardMaterial3D
@onready var left_light_beam: SpotLight3D = $KenneyVanBody/LeftLightBeam
@onready var right_light_beam: SpotLight3D = $KenneyVanBody/RightLightBeam

# Gear Icons
var drive_icon : CompressedTexture2D = preload("res://assets/ui/driving/driving.png")
var reverse_icon : CompressedTexture2D = preload("res://assets/ui/driving/reverse.png")
var neutral_icon : CompressedTexture2D = preload("res://assets/ui/driving/neutral.png")
var park_icon : CompressedTexture2D = preload("res://assets/ui/driving/park.png")

# Icons
var handbrake_on : CompressedTexture2D = preload("res://assets/ui/driving/icons/handbrake_on.png")
var handbrake_off : CompressedTexture2D = preload("res://assets/ui/driving/icons/handbrake_off.png")
var sidelights_on : CompressedTexture2D = preload("res://assets/ui/driving/icons/sidelights_on.png")
var sidelights_off : CompressedTexture2D = preload("res://assets/ui/driving/icons/sidelights_off.png")
var headlights_on : CompressedTexture2D = preload("res://assets/ui/driving/icons/headlights_on.png")
var headlights_off : CompressedTexture2D = preload("res://assets/ui/driving/icons/headlights_off.png")
var fullbeam_on : CompressedTexture2D = preload("res://assets/ui/driving/icons/full_beam_on.png")
var fullbeam_off : CompressedTexture2D = preload("res://assets/ui/driving/icons/full_beam_off.png")
# directional arrow
@onready var directional_arrow: DirectionalArrow = $DirectionalArrow

# Music
@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D

func _ready() -> void:
	speed_label.text = "0"
	speedometer.visible = false
	SignalManager.new_delivery_accepted.connect(_show_directional_arrow)
	
	if GameManager.handbrake_engaged:
		handbrake.texture = handbrake_on
	else:
		handbrake.texture = handbrake_off
	
	left_light_beam.visible = false
	right_light_beam.visible = false
	
	if rear_light_material:
		rear_light_material.emission_enabled = false
	else:
		push_error("No material assigned to Rear Lights")
	
	if front_light_material:
		front_light_material.emission_enabled = false
	else:
		push_error("No material assigned to Front Lights")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("park"):
		_engage_parking_break()
	if event.is_action_pressed("speed_limiter"):
		GameManager.is_speed_limiter_active = !GameManager.is_speed_limiter_active
	if event.is_action_pressed("vehicle_lights"):
		_cycle_lights()
	if event.is_action_pressed("full_beam_lights"):
		_toggle_full_beam()

func _physics_process(delta):
	if not is_player_inside:
		return
	
	if GameManager.handbrake_engaged:
		$wheel_front_left.brake = 1000.0
		$wheel_front_right.brake = 1000.0
		$wheel_rear_left.brake = 1000.0
		$wheel_rear_right.brake = 1000.0
		# Prevent tiny physics movement
		# TODO: investigate weird model behaviour when using this
		#if linear_velocity.length() < 0.5:
			#linear_velocity = Vector3.ZERO
	else:
		$wheel_front_left.brake = 0
		$wheel_front_right.brake = 0
		$wheel_rear_left.brake = 0
		$wheel_rear_right.brake = 0
	
	var speed_mph = linear_velocity.length() * 2.23694
	whole_speed = (int(round(speed_mph)))
	speed_label.text = str(whole_speed)
	
	speed = linear_velocity.length() * Engine.get_frames_per_second() * delta
	forward_speed = linear_velocity.dot(-transform.basis.z)
	traction(speed)
	process_accel(delta)
	process_steer(delta)
	process_brake(delta)
	_process_gears()

func process_accel(_delta):
	if Input.is_action_pressed("drive"):
		# Increase engine force at low speeds to make the initial acceleration faster.
		#if forward_speed >= -1:
			#if speed < 30 and speed != 0:
				#engine_force = clamp(engine_force_value * 10 / speed, 0, 300)
			#else:
				#engine_force = engine_force_value
		#engine_force = engine_force * gear_multiplicator
		#return
		engine_force = engine_force_value
		is_braking = false
		return
	
	if Input.is_action_pressed("brake"):
		# Increase engine force at low speeds to make the initial acceleration faster.
		#if speed < 20 and speed != 0:
			#engine_force = -clamp(engine_force_value * 3 / speed, 0, 300)
		#else:
			#engine_force = -engine_force_value
		#return
		engine_force = -engine_force_value
		is_braking = true
		return
	
	is_braking = false
	
	engine_force = 0
	brake = 0

func process_steer(delta):
	steer_target = Input.get_action_strength("left") - Input.get_action_strength("right")
	steer_target *= STEER_LIMIT
	steering = move_toward(steering, steer_target, STEER_SPEED * delta)

func process_brake(_delta):
	if Input.is_action_pressed("ui_select"):
		brake=0.5
		$wheel_rear_left.wheel_friction_slip=2
		$wheel_rear_right.wheel_friction_slip=2
	else:
		$wheel_rear_left.wheel_friction_slip=2.9
		$wheel_rear_right.wheel_friction_slip=2.9

func _process_gears() -> void:
	var forward_direction = -global_transform.basis.z
	var movement_direction = linear_velocity.normalized()

	var direction = forward_direction.dot(movement_direction)
	if GameManager.handbrake_engaged:
		gears.texture = park_icon
	elif whole_speed == 0:
		gears.texture = neutral_icon
	else:
		if direction > 0:
			gears.texture = reverse_icon
		if direction < 0 :
			gears.texture = drive_icon

func traction(_traction_speed):
	#apply_central_force(Vector3.DOWN * traction_speed)
	apply_central_force(-linear_velocity * 25.0)

func _process(_delta: float) -> void:
	if !is_player_inside:
		return
	
	if Input.is_action_just_pressed("replace"):
		exit_vehicle()
	
	_show_lights()

func show_input_prompt(prompt: InputPrompt) -> void:
	if !is_player_inside:
		prompt.display_prompt("interact", "Enter")

func interact(p: Player) -> void:
	player = p
	p.enter_vehicle(self)
	speedometer.visible = true
	_show_directional_arrow()
	audio_stream_player_3d.play(GameManager.vehicle_audio_position)

func exit_vehicle() -> void:
	if player:
		player.exit_vehicle(self)
		speedometer.visible = false
		directional_arrow.disable()
		GameManager.vehicle_audio_position = audio_stream_player_3d.get_playback_position()
		audio_stream_player_3d.stop()

func _show_directional_arrow() -> void:
	if GameManager.use_directional_arrow and OrderManager.active_delivery != null and GameManager.is_in_vehicle:
		directional_arrow.initialize_arrow()

func _engage_parking_break() -> void:
	GameManager.handbrake_engaged = !GameManager.handbrake_engaged
	
	if GameManager.handbrake_engaged:
		handbrake.texture = handbrake_on
	else:
		handbrake.texture = handbrake_off

func _cycle_lights() -> void:
	lights = ((lights + 1) % 3) as Lights

func _show_lights() -> void:
	if is_braking:
		_brake_lights_on()
		if lights == Lights.OFF:
			is_fullbeam = false
			sidelights.texture = sidelights_off
			headlights.texture = headlights_off
			full_beam.texture = fullbeam_off
			front_light_material.emission_enabled = false
			left_light_beam.visible = false
			right_light_beam.visible = false
		elif lights == Lights.SIDELIGHTS:
			sidelights.texture = sidelights_on
		elif lights == Lights.HEADLIGHTS:
			headlights.texture = headlights_on
			front_light_material.emission_enabled = true
			front_light_material.emission_energy_multiplier = 1.0
			left_light_beam.visible = true
			right_light_beam.visible = true
	else:
		if lights == Lights.OFF:
			is_fullbeam = false
			sidelights.texture = sidelights_off
			headlights.texture = headlights_off
			full_beam.texture = fullbeam_off
			rear_light_material.emission_enabled = false
			front_light_material.emission_enabled = false
			left_light_beam.visible = false
			right_light_beam.visible = false
		elif lights == Lights.SIDELIGHTS:
			sidelights.texture = sidelights_on
			rear_light_material.emission_enabled = true
			rear_light_material.emission_energy_multiplier = 1.0
		elif lights == Lights.HEADLIGHTS:
			headlights.texture = headlights_on
			front_light_material.emission_enabled = true
			front_light_material.emission_energy_multiplier = 1.0
			left_light_beam.visible = true
			right_light_beam.visible = true

func _toggle_full_beam() -> void:
	if lights == Lights.HEADLIGHTS:
		if is_fullbeam:
			# turn full beam off
			is_fullbeam = false
			headlights.texture = headlights_on
			full_beam.texture = fullbeam_off
			front_light_material.emission_energy_multiplier = 1.0
			left_light_beam.spot_range = 15.0
			left_light_beam.spot_attenuation = 1.0
			left_light_beam.spot_angle = 20.0
			right_light_beam.spot_range = 15.0
			right_light_beam.spot_attenuation = 1.0
			right_light_beam.spot_angle = 20.0
		else:
			# turn full beam on
			is_fullbeam = true
			headlights.texture = headlights_off
			full_beam.texture = fullbeam_on
			front_light_material.emission_energy_multiplier = 2.0
			left_light_beam.spot_range = 25.0
			left_light_beam.spot_attenuation = 2.0
			left_light_beam.spot_angle = 30.0
			right_light_beam.spot_range = 25.0
			right_light_beam.spot_attenuation = 2.0
			right_light_beam.spot_angle = 30.0
			

func _brake_lights_on() -> void:
	rear_light_material.emission_enabled = true
	rear_light_material.emission_energy_multiplier = 3.0
