extends StaticBody3D

class_name DeliveryCrate

func interact(_player: Player) -> void:
	print("Interacted with the Delivery Crate!")

func get_interaction_tooltip() -> String:
	if TheOrderManager.active_order.is_picked:
		return "Press E to Pick Up"
	return "Delivery Crate"
