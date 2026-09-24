extends Node3D

class_name Town

@onready var vehicle: Node3D = $Vehicle
@onready var player: Player = $Player

func _ready() -> void:
	LoadingOverlay.toggle_loading(false)
	
	# Use Player position if not (0,0,0)
	if GameManager.player_position != Vector3.ZERO:
		player.global_position = GameManager.player_position
	if GameManager.player_rotation != Vector3.ZERO:
		player.global_rotation = GameManager.player_rotation
	
	# Use Vehicle position if not (0,0,0)
	if GameManager.van_position != Vector3.ZERO:
		vehicle.global_position = GameManager.van_position
	if GameManager.van_rotation != Vector3.ZERO:
		vehicle.global_rotation = GameManager.van_rotation
