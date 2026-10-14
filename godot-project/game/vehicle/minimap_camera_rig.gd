extends Node3D

@onready var van: Vehicle = $".."
@onready var camera_3d: Camera3D = $SubViewport/Camera3D

func _process(_delta: float) -> void:
	# Set Camera position to follow van
	camera_3d.global_position.x = van.global_position.x
	camera_3d.global_position.y = 50.0
	camera_3d.global_position.z = van.global_position.z
	
	if not GameManager.static_minimap:
		# Set camera rotation to rotate minimap
		camera_3d.rotation_degrees.x = -90.0
		camera_3d.rotation.y = van.rotation.y
		camera_3d.rotation_degrees.z = 90
