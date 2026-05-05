extends VehicleBody3D

class_name Vehicle

@export var STEER_SPEED = 1.5
@export var STEER_LIMIT = 0.6
var steer_target = 0
@export var engine_force_value = 40

var gearshift = 3
var gear_multiplicator = 1
var gear_locked = false

var fwd_mps : float
var speed: float

var is_player_inside = false
var player : Player = null

func _physics_process(delta):
	if not is_player_inside:
		return
	
	speed = linear_velocity.length()*Engine.get_frames_per_second()*delta
	fwd_mps = transform.basis.x.x
	traction(speed)
	process_accel(delta)
	process_steer(delta)
	process_brake(delta)

func process_accel(delta):
	if Input.is_action_pressed("forwards"):
		# Increase engine force at low speeds to make the initial acceleration faster.
		if fwd_mps >= -1:
			if speed < 30 and speed != 0:
				engine_force = clamp(engine_force_value * 10 / speed, 0, 300)
			else:
				engine_force = engine_force_value
		engine_force = engine_force * gear_multiplicator
		return
	
	if Input.is_action_pressed("backwards"):
	# Increase engine force at low speeds to make the initial acceleration faster.
		if speed < 20 and speed != 0:
			engine_force = -clamp(engine_force_value * 3 / speed, 0, 300)
		else:
			engine_force = -engine_force_value
		return
	engine_force = 0
	brake = 0

func process_steer(delta):
	steer_target = Input.get_action_strength("left") - Input.get_action_strength("right")
	steer_target *= STEER_LIMIT
	steering = move_toward(steering, steer_target, STEER_SPEED * delta)

func process_brake(delta):
	if Input.is_action_pressed("ui_select"):
		brake=0.5
		$wheel_rear_left.wheel_friction_slip=2
		$wheel_rear_right.wheel_friction_slip=2
	else:
		$wheel_rear_left.wheel_friction_slip=2.9
		$wheel_rear_right.wheel_friction_slip=2.9

func traction(speed):
	apply_central_force(Vector3.DOWN*speed)

func _process(_delta: float) -> void:
	if !is_player_inside:
		return
	
	if Input.is_action_just_pressed("interact"):
		exit_vehicle()

func get_interaction_tooltip(_player: Player) -> String:
	return "Delivery Van\nPress E to Enter"

func interact(p: Player) -> void:
	player = p
	p.enter_vehicle(self)

func exit_vehicle() -> void:
	if player:
		player.exit_vehicle(self)
