extends StaticBody3D

func get_interaction_tooltip(_player: Player) -> String:
	return "Press E to Rest Until Tomorrow"

func interact(player: Player) -> void:
	print("Let's wait until morning")
	player.fade_out()
	GameTimeManager.rest()
	await get_tree().create_timer(1.5).timeout
	player.fade_in()
