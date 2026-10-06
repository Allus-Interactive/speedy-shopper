extends StaticBody3D

class_name DeliveryCrate

func interact(player: Player) -> void:
	if not player.is_carrying_stool:
		if _order_is_picked():
			player.pick_up_delivery_crate(self)
			if TutorialManager.current_step == TutorialManager.Step.PICK_UP_TRAY:
				TutorialManager.next_step()

func show_input_prompt(prompt: InputPrompt) -> void:
	if _order_is_picked():
		prompt.display_prompt("interact", "Pick Up")
	else:
		prompt.display_prompt("none", "Delivery Crate")

func _order_is_picked() -> bool:
	var active_order = OrderManager.active_order
	if active_order:
		return OrderManager.active_order.is_picked
	return false
