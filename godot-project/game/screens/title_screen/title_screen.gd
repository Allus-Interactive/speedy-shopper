extends Control

class_name TitleScreen

func _on_play_button_pressed() -> void:
	GameManager.thread_load_scene(Constants.SHOP_SCENE)

func _on_tutorial_button_pressed() -> void:
	TutorialManager.tutorial_enabled = true
	
	GameManager.thread_load_scene(Constants.SHOP_SCENE)

func _on_settings_button_pressed() -> void:
	get_tree().change_scene_to_file(Constants.SETTINGS_SCREEN)
