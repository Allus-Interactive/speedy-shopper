extends Control

@export var transition_time: float = 1.5

func _ready() -> void:
	SceneTransition.fade_in(transition_time)
	
	await get_tree().create_timer(transition_time + 1).timeout
	
	SceneTransition.fade_out(transition_time)
	
	await get_tree().create_timer(transition_time + 1).timeout
	
	get_tree().change_scene_to_file(Constants.SPLASHSCREEN_TITLE)
