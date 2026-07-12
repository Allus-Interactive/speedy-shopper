extends StaticBody3D

class_name Footstool

@onready var collision_shape_top: FootstoolTop = $CollisionShapeTop

func get_interaction_tooltip(player: Player) -> String:
	var stool = player.ray_cast_3d.get_collider()
	print("stool: ", stool)
	return "An Footstool"
