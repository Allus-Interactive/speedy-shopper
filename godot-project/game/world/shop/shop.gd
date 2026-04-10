extends Node3D

@onready var crate_hold_point: Marker3D = $CrateHoldPoint
@onready var delivery_crate: DeliveryCrate = $CrateHoldPoint/DeliveryCrate

func _ready() -> void:
	TheGameManager.crate_hold_point = crate_hold_point
	TheGameManager.delivery_crate = delivery_crate
