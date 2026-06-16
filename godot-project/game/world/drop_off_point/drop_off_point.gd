extends StaticBody3D

class_name DropOffPoint

@export var customer_details: Customer

func get_interaction_tooltip(_player: Player) -> String:
	return "Press E to Knock"

func interact(player: Player) -> void:
	if OrderManager.active_order == null:
		print("You don't have anything to deliver!")
		return
	
	var address = customer_details.address
	var order_address = OrderManager.active_order.delivery_address
	
	if _order_is_picked():
		if address == order_address:
			print("Order Delivered")
			player.complete_order()
		else:
			print("Wrong House")
	else:
		print("You haven't finished picking the order!")

func _order_is_picked() -> bool:
	var active_order = OrderManager.active_order
	if active_order:
		return OrderManager.active_order.is_picked
	return false
