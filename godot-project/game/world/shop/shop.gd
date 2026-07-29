extends Node3D

@onready var crate_hold_point: Marker3D = $CrateHoldPoint
@onready var delivery_crate: DeliveryCrate = $CrateHoldPoint/DeliveryCrate

func _ready() -> void:
	GameManager.crate_hold_point = crate_hold_point
	GameManager.delivery_crate = delivery_crate
	
	if TutorialManager.tutorial_enabled:
		play_the_tutorial()
	
	LoadingOverlay.toggle_loading(false)

func play_the_tutorial():
	print("Let's do the tutorial!")
	JobManager.generate_tutorial_order()
	
	# TODO: Dialogue that takes player through basics of picking orders
