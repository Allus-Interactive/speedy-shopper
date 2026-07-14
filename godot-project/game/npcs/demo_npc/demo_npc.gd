extends StaticBody3D

class_name DemoNPC

func interact(player: Player) -> void:
	print("Speak to NPC: ", str(DialogManager.dialog_ui))
	player.is_speaking_to_npc = true
	DialogManager.dialog_ui.dialog_panel.visible = true
	DialogManager.dialog_ui.set_text("Hi hi! You must be new, welcome!")
	# TODO: work on dialog system

func get_interaction_tooltip(_player: Player) -> String:
	return "Press E - Speak to NPC"
