extends StaticBody3D

class_name Footstool

func get_interaction_tooltip(player: Player) -> String:
	# Get the player's interaction raycast.
	var raycast = player.ray_cast_3d
	
	# Only continue if the raycast is currently hitting this footstool.
	if raycast.is_colliding():
		# Get the object that was hit and the exact world-space position of the collision.
		var collider = raycast.get_collider()
		var hit_pos = raycast.get_collision_point()
		
		# Convert the collision point from world space into the footstool's local space.
		# This allows us to determine where on the stool it was hit regardless of
		# its position or rotation in the world.
		var local_hit = collider.to_local(hit_pos)
		
		# If the player is looking at the top section of the stool, offer to stand on it.
		# Otherwise, they're looking at the lower section, so offer to pick it up instead.
		if local_hit.y > 1.5:
			print("Top half")
			return "Press E - Stand on Footstool"
		else:
			print("Bottom half")
			return "Press E - Pick up Footstool"
	
	# If the raycast isn't hitting a specific interaction area, just display the object name.
	return "A Footstool"
