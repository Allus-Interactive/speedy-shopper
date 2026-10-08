extends Node3D

class_name Town

@onready var vehicle: Node3D = $Vehicle
@onready var player: Player = $Player

func _ready() -> void:
	LoadingOverlay.toggle_loading(false)
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	player.auto_save_icon.visible = true
	
	# Use Player position if not (0,0,0) and loading from title screen
	if GameManager.previous_scene == "Title":
		if GameManager.player_position != Vector3.ZERO:
			player.global_position = GameManager.player_position
		if GameManager.player_rotation != Vector3.ZERO:
			player.global_rotation = GameManager.player_rotation
	
	# store player position
	GameManager.player_position = self.global_position
	GameManager.player_rotation = self.global_rotation
	
	# Use Vehicle position if not (0,0,0)
	if GameManager.van_position != Vector3.ZERO:
		vehicle.global_position = GameManager.van_position
	if GameManager.van_rotation != Vector3.ZERO:
		vehicle.global_rotation = GameManager.van_rotation
	
	# Save Data
	SaveLoadManager.save_game_data()
	
	await get_tree().create_timer(2.0).timeout

	player.auto_save_icon.visible = false
