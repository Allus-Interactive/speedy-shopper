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
	LOADING_TRAY,
	SET_DELIVERY,
	COMPLETE,
	FINISHED
}

var current_step: Step = Step.MOVE
var tutorial_enabled = false

func next_step() -> void:
	current_step = (current_step + 1) as Step
	update_ui()

func update_ui() -> void:
	match current_step:
		Step.MOVE:
			GameManager.tutorial_label.text = "Hello there, and welcome to Speedy Shopper!\nUse WASD to move and the mouse to look around."
		Step.OPEN_SCANNER:
			GameManager.tutorial_label.text = "Press Tab to open your PDA."
		Step.ACCEPT_ORDER:
			GameManager.tutorial_label.text = "At the moment, you only have one order. Press Space to accept it\nWhen you have mulitple orders, choose between them with the arrow keys."
		Step.PICK_FIRST_ITEM:
			GameManager.tutorial_label.text = "The first item is a loaf of bread. Go find it, press E in pick it up, WASD to rotate it and scan the barcode with your mouse."
		Step.PICK_SECOND_ITEM:
			GameManager.tutorial_label.text = "Congratulations! You scanned your first item. Now let's see what's next. Remember to re-open your scanner to see what the next item is"
		Step.PICK_THIRD_ITEM:
			GameManager.tutorial_label.text = "Nice one. Now let's try marking an item as unavailable. This is handy for when an item is out of stock. Open the scanner and select the milk. The red outline helps you see what item is selected. Then press Space."
		Step.PICK_LAST_ITEM:
			GameManager.tutorial_label.text = "Sweet! That's a nice way to let customers know we don't have that item. Just one more item to get now. Let's go pick it."
		Step.PICK_UP_TRAY:
			GameManager.tutorial_label.text = "You picked the order, well done! Return to the front of the shop and pick up the blue tray."
		Step.RETURN_TO_COUNTER:
			GameManager.tutorial_label.text = "Once you have picked an order, you need to drop the tray off at the Kiosk in the corner. It is loaded into your van for you."
		Step.LOADING_TRAY:
			GameManager.tutorial_label.text = "Let's have a breather while the tray is loaded."
		Step.SET_DELIVERY:
			GameManager.tutorial_label.text = "Great, now that the tray is loaded let's open the scanner again. Once all your current orders are picked, you see the list of addresses. Select an address with Space to mark it as ready for delivery."
		Step.COMPLETE:
			GameManager.tutorial_label.text = "Great, now you're ready to make your first delivery! When you get to the address, knock on the door and complete the order. Remember, you can't actually deliver an order until it is marked for delivery.\nAnd that's it! Leave the shop to end the tutorial. Happy Trails!"
