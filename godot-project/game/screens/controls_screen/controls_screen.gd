extends Control

@onready var sfx_player: SfxPlayer = $SFXPlayer

@onready var button_press_sfx: AudioStream = preload("res://assets/sfx/button_press.mp3")

func _ready() -> void:
	pass

func _on_back_button_pressed() -> void:
	sfx_player.play_sfx(button_press_sfx)
	await get_tree().create_timer(0.1).timeout
	get_tree().change_scene_to_file(Constants.TITLE_SCREEN)
