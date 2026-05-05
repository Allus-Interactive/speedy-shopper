extends StaticBody3D

class_name ExitEntry

@export var is_in_shop: bool = true

func get_interaction_tooltip(_player: Player) -> String:
	if is_in_shop:
		return "Press E to Leave"
	else:
		return "Press E to Enter"

func interact(_p: Player) -> void:
	if is_in_shop:
		get_tree().change_scene_to_file(Constants.DRIVING_SCENE)
	else:
		get_tree().change_scene_to_file(Constants.SHOP_SCENE)
	
