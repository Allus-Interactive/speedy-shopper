extends Control

class_name TitleScreen

@onready var sfx_player: SfxPlayer = $SFXPlayer

@onready var button_press_sfx: AudioStream = preload("res://assets/sfx/button_press.mp3")

# Settings
var config = ConfigFile.new()
var music_bus : int = GameManager.music_bus
var sfx_bus : int = GameManager.sfx_bus

func _ready() -> void:
	load_settings()

func load_settings() -> void:
	if config.load("user://speedy_shopper_settings.cfg") == OK:
		GameManager.music_volume = config.get_value("audio", "music", 0)
		GameManager.sfx_volume = config.get_value("audio", "sfx", 0)
		
		AudioServer.set_bus_volume_db(music_bus, GameManager.music_volume)
		AudioServer.set_bus_volume_db(sfx_bus, GameManager.sfx_volume)

func _on_play_button_pressed() -> void:
	sfx_player.play_sfx(button_press_sfx)
	await get_tree().create_timer(0.1).timeout
	
	GameManager.thread_load_scene(Constants.SHOP_SCENE)

func _on_tutorial_button_pressed() -> void:
	sfx_player.play_sfx(button_press_sfx)
	await get_tree().create_timer(0.1).timeout
	
	TutorialManager.tutorial_enabled = true
	
	GameManager.thread_load_scene(Constants.SHOP_SCENE)

func _on_settings_button_pressed() -> void:
	sfx_player.play_sfx(button_press_sfx)
	await get_tree().create_timer(0.1).timeout
	
	get_tree().change_scene_to_file(Constants.SETTINGS_SCREEN)
