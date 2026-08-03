extends Control

class_name SettingsScreen#


func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file(Constants.TITLE_SCREEN)
