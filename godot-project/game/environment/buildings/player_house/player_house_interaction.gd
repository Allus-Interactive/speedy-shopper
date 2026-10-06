extends StaticBody3D

func show_input_prompt(prompt: InputPrompt) -> void:
	prompt.display_prompt("interact", "Rest Until Tomorrow")

func interact(player: Player) -> void:
	player.fade_out()
	await get_tree().create_timer(1.5).timeout
	GameTimeManager.rest()
	player.fade_in()
