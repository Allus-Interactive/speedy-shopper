extends StaticBody3D

class_name DeliveryKiosk

@onready var crate_hold_point: Marker3D = $CrateHoldPoint

func interact(player: Player) -> void:
	if _order_is_picked():
		player.put_down_delivery_crate(self)

func get_interaction_tooltip(player: Player) -> String:
	if _order_is_picked():
		return "Press E to Complete the Order"
	return "Delivery Kiosk"

func _order_is_picked() -> bool:
	var active_order = TheOrderManager.active_order
	if active_order:
		return TheOrderManager.active_order.is_picked
	return false
