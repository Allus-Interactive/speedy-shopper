extends CharacterBody3D

class_name Player

# Movement
const WALK_SPEED: float = 5.0
const CROUCH_SPEED: float = 2.0
const JUMP_VELOCITY: float = 4.5

# Crouching
var is_crouching: bool = false
var standing_neck_height: float = 1.6
var crouching_neck_height: float = 1.0
var crouch_lerp_speed: float = 10.0

# Vehicle variables
var vehicle: Vehicle = null
var is_in_vehicle: bool = false

var is_carrying_crate: bool = false
var delivery_crate: DeliveryCrate = null

# Product Inspect variables
var held_product: ProductPlaceholder = null
var held_product_original_parent: Node = null
var held_product_original_transform: Transform3D
var is_inspecting_product: bool = false
@export var inspect_rotation_speed: float = 2.0
@onready var hold_point: Marker3D = $Neck/Camera3D/HoldPoint
@onready var crate_hold_point: Marker3D = $Neck/Camera3D/CrateHoldPoint

# Camera
@onready var neck: Node3D = $Neck
@onready var camera: Camera3D = $Neck/Camera3D
@onready var ray_cast_3d: RayCast3D = $Neck/Camera3D/RayCast3D

# UI
@onready var crosshair: ColorRect = $CanvasLayer/Control/Crosshair
@onready var tooltip_panel: Panel = $CanvasLayer/Control/TooltipPanel
@onready var tooltip_label: Label = $CanvasLayer/Control/TooltipPanel/TooltipLabel
@onready var earnings_label: Label = $UiPanel/EarningsLabel

# Scanner
@onready var scanner_ui: ScannerUI = $ScannerUI

func _ready() -> void:
	tooltip_panel.hide()

func _unhandled_input(event: InputEvent) -> void:
	# Capture mouse input when not inspecting a product
	if not is_inspecting_product:
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
			camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-45), deg_to_rad(45))

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
	
	is_crouching = Input.is_action_pressed("crouch")
	
	update_crouch(delta)
	
	var movement_speed = CROUCH_SPEED if is_crouching else WALK_SPEED
	
	var input_dir := Input.get_vector("left", "right", "forwards", "backwards")
	var direction = (neck.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * movement_speed
		velocity.z = direction.z * movement_speed
	else:
		velocity.x = move_toward(velocity.x, 0, movement_speed)
		velocity.z = move_toward(velocity.z, 0, movement_speed)
	
	# Update the interaction tooltip
	update_tooltip()
	# Move the player
	move_and_slide()

func _process(delta: float) -> void:
	if is_inspecting_product:
		handle_product_inspection_input(delta)
	
	# If holding product, replace on shelf
	if is_inspecting_product and Input.is_action_pressed("replace"):
		return_held_product()
	
	# Scan the barcode when clicked
	if is_inspecting_product and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		scan_barcode()
	
	if not is_inspecting_product and Input.is_action_just_pressed("toggle_scanner"):
		scanner_ui.toggle_scanner()
	
	# Check raycast for interactable object
	if Input.is_action_just_released("interact"):
		if ray_cast_3d.is_colliding():
			var obj = ray_cast_3d.get_collider()
			print("Player interacts with: ", obj)
			if obj.has_method("interact"):
				obj.interact(self)

func pick_up_product(product: ProductPlaceholder) -> void:	
	if is_inspecting_product:
		return
	
	# if scanner is open, close it
	if scanner_ui.is_open:
		scanner_ui.toggle_scanner()
	
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
	
	# Make the mouse visible
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	# Hide the crosshair and tooltip
	crosshair.hide()
	tooltip_panel.hide()
	
	product.disable_barcode_hitbox(false)

func pick_up_delivery_crate(crate: DeliveryCrate) -> void:
	# if scanner is open, close it
	if scanner_ui.is_open:
		scanner_ui.toggle_scanner()
	
	delivery_crate = crate
	is_carrying_crate = true
	
	# disable collision shape to avoid interference with raycasts or clipping
	if crate.has_node("CollisionShape3D"):
		crate.get_node("CollisionShape3D").disabled = true
	
	# Reparent to crate hold point and reset position and rotation
	crate.reparent(crate_hold_point)
	crate.position = Vector3.ZERO
	crate.rotation = Vector3.ZERO

func put_down_delivery_crate(kiosk: DeliveryKiosk) -> void:
	is_carrying_crate = false
	
	# Reparent to crate hold point and reset position and rotation
	delivery_crate.reparent(kiosk.crate_hold_point)
	delivery_crate.position = Vector3.ZERO
	delivery_crate.rotation = Vector3.ZERO
	
	complete_order()

func complete_order() -> void:
	# Pay the player
	TheGameManager.daily_earnings += calculate_player_tip()
	earnings_label.text = "Today's Earnings: £" + "%0.2f" % TheGameManager.daily_earnings
	
	# Wait for a lil bit
	await get_tree().create_timer(3.0).timeout
	
	# Reset the delivery crate (once order has been collected)
	TheGameManager.delivery_crate.reparent(TheGameManager.crate_hold_point)
	TheGameManager.delivery_crate.position = Vector3.ZERO
	TheGameManager.delivery_crate.rotation = Vector3.ZERO
	
	# re-enable collision shape
	if TheGameManager.delivery_crate.has_node("CollisionShape3D"):
		TheGameManager.delivery_crate.get_node("CollisionShape3D").disabled = false
	
	# Mark order as complete and clear active order
	TheOrderManager.active_order.is_completed = true
	# TODO: store order in completed_orders array before clearing active order?
	TheOrderManager.active_order = null

func calculate_player_tip() -> float:
	var order_price: float = TheOrderManager.active_order.price
	var tip_percentage: int = 15
	var player_tip: float = (order_price / 100) * tip_percentage
	return player_tip

func return_held_product() -> void:
	if held_product == null:
		return
	
	held_product.reparent(held_product_original_parent)
	held_product.global_transform = held_product_original_transform
	held_product.disable_barcode_hitbox(true)
	
	# enable collision shape
	if held_product.has_node("CollisionShape3D"):
		held_product.get_node("CollisionShape3D").disabled = false
	
	# Confine Mouse to screen
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	# Show the crosshair and tooltip
	crosshair.show()
	tooltip_panel.show()
	
	held_product = null
	held_product_original_parent = null
	is_inspecting_product = false

func collect_held_product() -> void:
	if held_product == null:
		return
	
	var product_to_remove = held_product
	
	held_product = null
	held_product_original_parent = null
	is_inspecting_product = false
	
	# Confine Mouse to screen
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	# Show the crosshair and hide the tooltip
	crosshair.show()
	tooltip_panel.hide()
	
	# Remove the product
	# TODO: move product to basket instead of deleting object
	product_to_remove.queue_free()

func scan_barcode() -> void:
	if held_product == null:
		return
	
	var mouse_pos := get_viewport().get_mouse_position()
	
	var from = camera.project_ray_origin(mouse_pos)
	var to = from + camera.project_ray_normal(mouse_pos) * 10.0
	
	var query := PhysicsRayQueryParameters3D.create(from, to)
	query.collide_with_areas = true
	query.collide_with_bodies = true
	
	var result := get_world_3d().direct_space_state.intersect_ray(query)
	
	if result.is_empty():
		return
	
	var collider = result["collider"]
	
	if collider != null and collider.has_meta("is_barcode") and collider.get_meta("is_barcode") == true:
		var owner_product = collider.get_meta("owner_product")
		if owner_product == held_product:
			if held_product.on_barcode_clicked():
				collect_held_product()
			else:
				print("Wrong Product!")
				# TODO: play wrong product scanned beep

# Update tooltip text and crosshair colour
func update_tooltip() -> void:
	# If there is no object
	if not ray_cast_3d.is_colliding():
		tooltip_panel.hide()
		crosshair.modulate = Color.WHITE
		return
	
	var obj = ray_cast_3d.get_collider()
	
	# if the object is null
	if obj == null:
		tooltip_panel.hide()
		crosshair.modulate = Color.WHITE
		return
	
	# If the object has the 'get_interaction_tooltip' function
	if obj.has_method("get_interaction_tooltip"):
		tooltip_label.text = obj.get_interaction_tooltip(self)
		tooltip_panel.show()
		crosshair.modulate = Color.DARK_GREEN
		return
	
	# if the object has the 'interact' function
	if obj.has_method("interact"):
		crosshair.modulate = Color.DARK_GREEN
		return

func update_crouch(delta: float) -> void:
	var target_neck_y = crouching_neck_height if is_crouching else standing_neck_height
	neck.position.y = lerp(neck.position.y, target_neck_y, crouch_lerp_speed * delta)

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
