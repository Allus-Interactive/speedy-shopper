extends Node3D

@onready var van: Vehicle = $".."
@onready var camera_3d: Camera3D = $SubViewport/Camera3D

func _process(_delta: float) -> void:
	# Set Camera position to follow van
	camera_3d.global_position = Vector3(
		van.global_position.x, 
		# Zoom level slider goes from -80 to -20. 
		# Value needs to be multiplied by -1 to get positive value
		GameManager.minimap_zoom_level * -1, 
		van.global_position.z
	)
	
	if not GameManager.static_minimap:
		# Set camera rotation to rotate minimap
		camera_3d.rotation_degrees = Vector3(
			-90.0,
			rad_to_deg(van.rotation.y),
			90.0
		)
