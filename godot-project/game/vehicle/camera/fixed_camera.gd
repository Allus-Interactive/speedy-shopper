extends Camera3D

@export_group("Camera Position")
@export var target_distance: float = 6.0
@export var target_height: float = 2.5
@export var follow_speed: float = 5.0

@export_group("Camera Rotation")
@export var mouse_sensitivity: float = 0.003
@export var controller_sensitivity: float = 2.0
@export var rotation_speed: float = 5.0
@export var min_pitch: float = -20.0
@export var max_pitch: float = 45.0
@export var pitch_smoothing: float = 10.0

@export_group("Controller")
@export var deadzone: float = 0.15

var follow_this: Node3D

# Camera yaw is stored relative to the van's heading.
var yaw: float = 0.0
var pitch: float = 10.0
var target_pitch: float = 10.0

var current_yaw: float = 0.0

func _ready() -> void:
	follow_this = get_parent() as Node3D
	
	if not is_instance_valid(follow_this):
		push_error("Van camera requires a Node3D parent.")
		set_physics_process(false)
		set_process_unhandled_input(false)
		return
		
	# Begin directly behind the van.
	current_yaw = follow_this.global_rotation.y
	yaw = 0.0
	
	pitch = 10.0
	target_pitch = pitch
	
	_update_camera_position(1.0)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		yaw -= event.relative.x * mouse_sensitivity
		
		target_pitch += (
			event.relative.y
			* mouse_sensitivity
			* rad_to_deg(1.0)
		)
		
		target_pitch = clampf(
			target_pitch,
			min_pitch,
			max_pitch
		)

func _physics_process(delta: float) -> void:
	if not is_instance_valid(follow_this):
		return
		
	_read_controller_input(delta)
	
	# Smoothly rotate with the van while retaining
	# the player's camera yaw offset.
	var van_yaw: float = follow_this.global_rotation.y
	var desired_yaw: float = van_yaw + yaw
	
	current_yaw = lerp_angle(
		current_yaw,
		desired_yaw,
		clampf(delta * rotation_speed, 0.0, 1.0)
	)
	
	# Smooth the camera's vertical viewing angle.
	pitch = lerp(
		pitch,
		target_pitch,
		clampf(delta * pitch_smoothing, 0.0, 1.0)
	)
	
	_update_camera_position(delta)

func _read_controller_input(delta: float) -> void:
	var look_input: Vector2 = Input.get_vector(
		"camera_left",
		"camera_right",
		"camera_up",
		"camera_down",
		deadzone
	)
	
	# Rotate relative to the van's heading.
	yaw -= look_input.x * controller_sensitivity * delta
	
	target_pitch += (
		look_input.y
		* controller_sensitivity
		* delta
		* rad_to_deg(1.0)
	)
	
	target_pitch = clampf(
		target_pitch,
		min_pitch,
		max_pitch
	)

func _update_camera_position(delta: float) -> void:
	var target: Vector3 = follow_this.global_position
	
	var rotation_basis: Basis = Basis.from_euler(
		Vector3(-deg_to_rad(pitch), current_yaw, 0.0)
	)
	
	var offset: Vector3 = rotation_basis * Vector3(
		0.0,
		0.0,
		target_distance
	)
	
	var desired_position: Vector3 = (
		target
		+ Vector3.UP * target_height
		+ offset
	)
	
	# Smoothly follow the van.
	global_position = global_position.lerp(
		desired_position,
		clampf(delta * follow_speed, 0.0, 1.0)
	)
	
	# Keep looking towards the van.
	look_at(
		target + Vector3.UP * target_height,
		Vector3.UP
	)
