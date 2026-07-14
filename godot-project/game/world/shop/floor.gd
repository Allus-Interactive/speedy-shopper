extends StaticBody3D

class_name Floor

func interact(player: Player) -> void:
	if player.is_carrying_stool:
		var place_point: Vector3 = player.ray_cast_3d.get_collision_point()
		player.put_down_footstool(self, place_point)

func get_interaction_tooltip(player: Player) -> String:
	if player.is_carrying_stool:
		return "Press E - Put down Stool"
	
	return ""
