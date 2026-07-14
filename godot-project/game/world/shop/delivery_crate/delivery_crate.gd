extends StaticBody3D

class_name DeliveryCrate

func interact(player: Player) -> void:
	if not player.is_carrying_stool:
		if _order_is_picked():
			player.pick_up_delivery_crate(self)

func get_interaction_tooltip(_player: Player) -> String:
	if _order_is_picked():
		return "Press E to Pick Up"
	return "Delivery Crate"

func _order_is_picked() -> bool:
	var active_order = OrderManager.active_order
	if active_order:
		return OrderManager.active_order.is_picked
	return false
