extends StaticBody3D

class_name DeliveryCrate

func interact(player: Player) -> void:
	print("Iteracted with the Delivery Crate!")

func get_interaction_tooltip() -> String:
	if TheOrderManager.active_order.get("picked"):
		return "Press E to Pick Up"
	return "Delivery Crate"
