extends StaticBody3D

class_name DropOffPoint

@export var customer_details: Customer

func get_interaction_tooltip(_player: Player) -> String:
	return "Press E to Knock"

func interact(player: Player) -> void:
	# TODO: 
	# - create delivery UI - phone showing picked orders to be delivered
	# - select order to deliver, set as active_delivery
	if OrderManager.active_delivery == null:
		GameManager.notification_ui.show_message("You have no active delivery!", false)
		return
	
	var address = customer_details.address
	var order_address = OrderManager.active_delivery.delivery_address
	
	if address == order_address:
		GameManager.notification_ui.show_message("Order successfully delivered!", true)
		player.complete_delivery()
	else:
		GameManager.notification_ui.show_message("Wrong Address!", false)

func _order_is_picked() -> bool:
	var active_order = OrderManager.active_order
	if active_order:
		return OrderManager.active_order.is_picked
	return false
