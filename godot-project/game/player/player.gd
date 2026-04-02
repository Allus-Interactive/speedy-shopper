extends CharacterBody3D

class_name Player

# Movement
const SPEED: float = 5.0
const JUMP_VELOCITY: float = 4.5

# Vehicle variables
var vehicle: Vehicle = null
var is_in_vehicle: bool = false

# Product Inspect variables
var held_product: Node3D = null
var held_product_original_parent: Node = null
var held_product_original_transform: Transform3D
var is_inspecting_product: bool = false
@export var inspect_rotation_speed: float = 2.0
@onready var hold_point: Marker3D = $Neck/Camera3D/HoldPoint

# Camera
@onready var neck: Node3D = $Neck
@onready var camera: Camera3D = $Neck/Camera3D
@onready var ray_cast_3d: RayCast3D = $Neck/Camera3D/RayCast3D

func _unhandled_input(event: InputEvent) -> void:
	# Capture mouse input
	if event is InputEventMouseButton:
		# Confine Mouse to screen
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event.is_action_pressed("ui_cancel"):
		# Make the mouse visible again
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	# Listen to mouse motion if not inspecting product
	if not is_inspecting_product:
		handle_player_look_input(event)

func handle_player_look_input(event: InputEvent) -> void:
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			neck.rotate_y(-event.relative.x * 0.01)
			camera.rotate_x(-event.relative.y * 0.01)
			# clamp rotation
			camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-30), deg_to_rad(60))

func handle_product_inspection_input(delta: float) -> void:
	if held_product == null:
		return
	
	var yaw: float = 0.0
	var pitch: float = 0.0
	var roll: float = 0.0
	
	if Input.is_action_pressed("product_rotate_left"):
		yaw += 1.0
	if Input.is_action_pressed("product_rotate_right"):
		yaw -= 1.0
	if Input.is_action_pressed("product_rotate_up"):
		pitch += 1.0
	if Input.is_action_pressed("product_rotate_down"):
		pitch -= 1.0
	if Input.is_action_pressed("product_roll_left"):
		roll += 1.0
	if Input.is_action_pressed("product_roll_right"):
		roll -= 1.0
	
	held_product.rotate_y(yaw * inspect_rotation_speed * delta)
	held_product.rotate_x(pitch * inspect_rotation_speed * delta)
	held_product.rotate_z(roll * inspect_rotation_speed * delta)

func _physics_process(delta: float) -> void:
	if is_inspecting_product:
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

func _process(delta: float) -> void:
	if is_inspecting_product:
		handle_product_inspection_input(delta)
	
	# If holding product, replace on shelf
	if is_inspecting_product and Input.is_action_pressed("replace"):
		return_held_product()
	
	if Input.is_action_just_released("interact"):
		if ray_cast_3d.is_colliding():
			var obj = ray_cast_3d.get_collider()
			print("Player interacts with: ", obj)
			if obj.has_method("interact"):
				obj.interact(self)

func pick_up_product(product: Node3D) -> void:	
	if is_inspecting_product:
		return
	
	held_product = product
	held_product_original_parent = product.get_parent()
	held_product_original_transform = product.global_transform
	is_inspecting_product = true
	
	# disable collision shape to avoid interference with raycasts or clipping
	if product.has_node("CollisionShape3D"):
		product.get_node("CollisionShape3D").disabled = true
	
	# Reparent to hold point
	held_product.reparent(hold_point)
	
	# Reset local transform so it sits on the hold point
	held_product.transform = Transform3D.IDENTITY

func return_held_product() -> void:
	if held_product == null:
		return
	
	held_product.reparent(held_product_original_parent)
	held_product.global_transform = held_product_original_transform
	
	# enable collision shape
	if held_product.has_node("CollisionShape3D"):
		held_product.get_node("CollisionShape3D").disabled = false
	
	held_product = null
	held_product_original_parent = null
	is_inspecting_product = false

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
