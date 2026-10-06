extends StaticBody3D

class_name Floor

func interact(player: Player) -> void:
	if player.is_carrying_stool:
		var place_point: Vector3 = player.ray_cast_3d.get_collision_point()
		player.put_down_footstool(self, place_point)

func show_input_prompt(prompt: InputPrompt) -> void:
	var player: Player = prompt.get_parent()
	
	if player.is_carrying_stool:
		prompt.display_prompt("interact", "Put Down Stool")
