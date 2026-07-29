extends StaticBody3D

class_name DeliveryKiosk

@onready var crate_hold_point: Marker3D = $CrateHoldPoint

func interact(player: Player) -> void:
	if _order_is_picked():
		player.put_down_delivery_crate(self, _is_order_for_pickup())
		if TutorialManager.current_step == TutorialManager.Step.RETURN_TO_COUNTER:
			TutorialManager.next_step()

func get_interaction_tooltip(player: Player) -> String:
	var active_order = OrderManager.active_order
	if active_order:
		if active_order.delivery_address == "Pickup" and player.is_carrying_crate:
			# Pickup order, order is complete when dropped at kiosk
			return "Press E to Complete the Order"
		elif player.is_carrying_crate:
			# Delivery order, order is complete when delivered to address
			return "Press E to Load into the Van"
	return "Delivery Kiosk"

func _order_is_picked() -> bool:
	var active_order = OrderManager.active_order
	if active_order:
		return OrderManager.active_order.is_picked
	return false

func _is_order_for_pickup() -> bool:
	var active_order = OrderManager.active_order
	if active_order.delivery_address == "Pickup":
		return true
	return false
