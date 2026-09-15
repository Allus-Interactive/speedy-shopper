extends Node3D

class_name Town

@onready var vehicle: Node3D = $Vehicle

func _ready() -> void:
	LoadingOverlay.toggle_loading(false)
	
	if GameManager.van_position != Vector3.ZERO:
		vehicle.global_position = GameManager.van_position
	if GameManager.van_rotation != Vector3.ZERO:
		vehicle.global_rotation = GameManager.van_rotation
