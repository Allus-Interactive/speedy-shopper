extends CharacterBody3D

class_name Player

const SPEED: float = 5.0
const JUMP_VELOCITY: float = 4.5

var vehicle : Vehicle = null
var is_in_vehicle : bool = false

@onready var neck: Node3D = $Neck
@onready var camera: Camera3D = $Neck/Camera3D
@onready var ray_cast_3d: RayCast3D = $Neck/RayCast3D

func _unhandled_input(event: InputEvent) -> void:
	# Capture mouse input
	if event is InputEventMouseButton:
		# Confine Mouse to screen
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event.is_action_pressed("ui_cancel"):
		# Make the mouse visible again
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	# Listen to mouse motion to rotate player view
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			neck.rotate_y(-event.relative.x * 0.01)
			camera.rotate_x(-event.relative.y * 0.01)
			# clamp rotation
			camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-30), deg_to_rad(60))

func _physics_process(delta: float) -> void:
	if is_in_vehicle:
		return
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	var input_dir := Input.get_vector("left", "right", "forwards", "backwards")
	var direction = (neck.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func _process(_delta: float) -> void:
	if Input.is_action_just_released("interact"):
		if ray_cast_3d.is_colliding():
			var obj = ray_cast_3d.get_collider()
			print("Player interacts with: ", obj)
			if obj.has_method("interact"):
				obj.interact(self)

func enter_vehicle(v: Vehicle) -> void:
	is_in_vehicle = true
	
	vehicle = v
	v.is_player_inside = true
	
	# hide player
	visible = false
	
	# move player to vehicle
	var seat_position = v.get_node("SeatPosition").global_position
	if seat_position:
		global_position = seat_position
	else:
		global_position = v.global_position
	
	# switch camera
	var van_camera = v.get_node("ThirdPersonCam")
	if v.get_node("ThirdPersonCam"):
		camera.current = false
		van_camera.current = true
	else:
		push_error("No Van Camera found")

func exit_vehicle(v: Vehicle) -> void:
	is_in_vehicle = false
	visible = true
	
	# move player beside veihcle
	#global_position = v.global_position + Vector3(2, 0, 0)
	
	# restore player camera
	var van_camera = v.get_node("ThirdPersonCam")
	if v.get_node("ThirdPersonCam"):
		van_camera.current = false
		camera.current = true
	else:
		push_error("No Van Camera found")
