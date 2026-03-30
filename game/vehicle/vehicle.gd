extends VehicleBody3D

class_name Vehicle

@export var max_speed : int = 25
@export var engine_power : int = 1200
@export var brake_power : int = 15
@export var steer_limit : float = 0.5

var is_player_inside = false
var player : Player = null

func _physics_process(_delta: float) -> void:
	if !is_player_inside:
		return
	
	if linear_velocity.length() > max_speed:
		linear_velocity = linear_velocity.normalized() * max_speed
	
	engine_force = 0
	brake = 0
	
	if Input.is_action_pressed("forwards"):
		print("Drive!")
		engine_force = engine_power
	
	if Input.is_action_pressed("backwards"):
		print("Brake")
		brake = brake_power
	
	steering = Input.get_axis("right", "left") * steer_limit

func _process(_delta: float) -> void:
	if !is_player_inside:
		return
	
	if Input.is_action_just_pressed("interact"):
		exit_vehicle()

func interact(p: Player) -> void:
	player = p
	p.enter_vehicle(self)

func exit_vehicle() -> void:
	if player:
		player.exit_vehicle(self)
