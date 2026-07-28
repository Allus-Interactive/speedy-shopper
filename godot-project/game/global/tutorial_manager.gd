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
	COMPLETE
}

var current_step: Step = Step.MOVE
var tutorial_enabled = true

func next_step() -> void:
	current_step += 1
	update_ui()

func update_ui() -> void:
	print("Upodate the UI")
