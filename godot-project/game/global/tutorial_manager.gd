extends Node

enum Step {
	MOVE,
	OPEN_SCANNER,
	ACCEPT_ORDER,
	PICK_FIRST_ITEM,
	PICK_SECOND_ITEM,
	PICK_THIRD_ITEM,
	PICK_LAST_ITEM,
	PICK_UP_TRAY,
	RETURN_TO_COUNTER,
	COMPLETE,
	FINISHED
}

var current_step: Step = Step.MOVE
var tutorial_enabled = false

func next_step() -> void:
	current_step += 1
	update_ui()

func update_ui() -> void:
	match current_step:
		Step.MOVE:
			GameManager.tutorial_label.text = "Hello there, and welcome to Speedy Shopper!\nUse WASD to move and the mouse to look around."
		Step.OPEN_SCANNER:
			GameManager.tutorial_label.text = "Press T to open your scanner."
		Step.ACCEPT_ORDER:
			GameManager.tutorial_label.text = "At the moment, you only have one order. Press Space to accept it\nWhen you have mulitple orders, choose between them with the arrow keys."
		Step.PICK_FIRST_ITEM:
			GameManager.tutorial_label.text = "The first item is a loaf of bread. Go find it, press E in pick it up, WASD to rotate it and scan the barcode with your mouse."
		Step.PICK_SECOND_ITEM:
			GameManager.tutorial_label.text = "Congratulations! You scanned your first item. Now let's see what's next. Remember to re-open your scanner to see what the next item is"
		Step.PICK_THIRD_ITEM:
			GameManager.tutorial_label.text = "That's it, you're getting the hang of it. What's next?"
		Step.PICK_LAST_ITEM:
			GameManager.tutorial_label.text = "Just one more item to get for this order. Let's go pick it."
		Step.PICK_UP_TRAY:
			GameManager.tutorial_label.text = "You picked the order, well done! Return to the front of the shop and pick up the blue tray."
		Step.RETURN_TO_COUNTER:
			GameManager.tutorial_label.text = "This is a Pickup order, you may have noticed that on the scanner. For those, you simply need to drop the tray off at the Kiosk in the corner."
		Step.COMPLETE:
			GameManager.tutorial_label.text = "Congratulations, you completed your first order! You'll find most orders require you to actually deliver it, but I'll leave that for you to explore. Good Luck!\nFeel free to leave the shop, and I'll see you soon!"
