extends Camera3D

@export_group("Camera Stability")
@export var rotation_smoothing: float = 5.0
@export var position_smoothing: float = 15.0
@export var pitch_influence: float = 0.15
@export var roll_influence: float = 0.0

var van: Node3D
var camera_local_position: Vector3

var target_yaw: float = 0.0
var current_yaw: float = 0.0
var target_pitch: float = 0.0
var current_pitch: float = 0.0
var target_roll: float = 0.0
var current_roll: float = 0.0

func _ready() -> void:
	van = get_parent() as Node3D
	
	if not is_instance_valid(van):
		push_error("First-person camera requires a Node3D parent.")
		set_physics_process(false)
		return
		
	# Preserve the camera's position inside the cab.
	camera_local_position = position
	
	# Start aligned with the van.
	target_yaw = van.global_rotation.y
	current_yaw = target_yaw

func _physics_process(delta: float) -> void:
	if not is_instance_valid(van):
		return
		
	# Read the van's orientation.
	var van_rotation: Vector3 = van.global_rotation
	
	target_yaw = van_rotation.y
	target_pitch = van_rotation.x * pitch_influence
	target_roll = van_rotation.z * roll_influence
	
	# Smooth the camera rotation.
	current_yaw = lerp_angle(
		current_yaw,
		target_yaw,
		clampf(delta * rotation_smoothing, 0.0, 1.0)
	)
	
	current_pitch = lerp_angle(
		current_pitch,
		target_pitch,
		clampf(delta * rotation_smoothing, 0.0, 1.0)
	)
	
	current_roll = lerp_angle(
		current_roll,
		target_roll,
		clampf(delta * rotation_smoothing, 0.0, 1.0)
	)
	
	# Follow the camera's original cab position.
	var target_position: Vector3 = van.to_global(
		camera_local_position
	)
	
	global_position = global_position.lerp(
		target_position,
		clampf(delta * position_smoothing, 0.0, 1.0)
	)
	
	# Apply a stable world-space orientation.
	global_rotation = Vector3(
		current_pitch,
		current_yaw + PI,
		current_roll
	)
