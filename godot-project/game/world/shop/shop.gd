extends Node3D

@onready var crate_hold_point: Marker3D = $CrateHoldPoint
@onready var delivery_crate: DeliveryCrate = $CrateHoldPoint/DeliveryCrate

@onready var player: Player = $Player

func _ready() -> void:
	# Set global position of player to override saved values used for town scene
	player.global_position = Vector3(-5.5, 0, 0)
	player.global_rotation = Vector3.ZERO
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	GameManager.previous_scene = "Shop"
	
	GameManager.crate_hold_point = crate_hold_point
	GameManager.delivery_crate = delivery_crate
	
	if TutorialManager.tutorial_enabled:
		play_the_tutorial()
	else:
		# Save the Game
		player.auto_save_icon.visible = true
		SaveLoadManager.save_game_data()
		await get_tree().create_timer(2.0).timeout
		player.auto_save_icon.visible = false
	
	LoadingOverlay.toggle_loading(false)


func play_the_tutorial():
	JobManager.generate_tutorial_order()
	
	# TODO: Dialogue that takes player through basics of picking orders
