extends Control

class_name SettingsScreen#

@onready var music_slider: HSlider = $MusicSlider
@onready var sfx_slider: HSlider = $SfxSlider
@onready var sfx_player: SfxPlayer = $SFXPlayer
@onready var time_check_button: CheckButton = $TimeCheckButton
@onready var arrow_navigation_button: CheckButton = $ArrowNavigationButton
@onready var confirmation_popup_overlay: ColorRect = $ConfirmationPopupOverlay
@onready var cancel_button: TextureButton = $ConfirmationPopupOverlay/ConfirmationPopup/CancelButton
@onready var delete_confirm_label: Label = $DeleteConfirmLabel
@onready var disable_prompts_label: Label = $DisablePromptsLabel
@onready var disable_prompts_button: CheckButton = $DisablePromptsButton
@onready var back_button: TextureButton = $BackButton
@onready var button_press_sfx: AudioStream = preload("res://assets/sfx/button_press.mp3")

var music_bus : int = GameManager.music_bus
var sfx_bus : int = GameManager.sfx_bus

var config = ConfigFile.new()

func _ready() -> void:
	# Load saved settings
	load_settings()
	
	confirmation_popup_overlay.visible = false
	delete_confirm_label.visible = false
	
	# Set UI to current settings
	music_slider.value = GameManager.music_volume
	sfx_slider.value = GameManager.sfx_volume
	time_check_button.button_pressed = GameManager.use_24_hour
	arrow_navigation_button.button_pressed = GameManager.use_directional_arrow
	disable_prompts_button.button_pressed = GameManager.disable_prompts
	
	back_button.grab_focus()

func save_settings() -> void:
	config.set_value("audio", "music", music_slider.value)
	config.set_value("audio", "sfx", sfx_slider.value)
	config.set_value("button", "time", time_check_button.button_pressed)
	config.set_value("button", "arrow", arrow_navigation_button.button_pressed)
	config.set_value("button", "prompts", disable_prompts_button.button_pressed)
	config.save("user://speedy_shopper_settings.cfg")

func load_settings() -> void:
	if config.load("user://speedy_shopper_settings.cfg") == OK:
		music_slider.value = config.get_value("audio", "music", 0)
		sfx_slider.value = config.get_value("audio", "sfx", 0)
		time_check_button.button_pressed = config.get_value("button", "time", 0)
		arrow_navigation_button.button_pressed = config.get_value("button", "arrow", 0)
		disable_prompts_button.button_pressed = config.get_value("button", "prompts", 0)

func _on_music_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(music_bus, value)
	GameManager.music_volume = value

func _on_sfx_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(sfx_bus, value)
	GameManager.sfx_volume = value

func _on_time_check_button_toggled(toggled_on: bool) -> void:
	GameManager.use_24_hour = toggled_on

func _on_arrow_navigation_button_toggled(toggled_on: bool) -> void:
	GameManager.use_directional_arrow = toggled_on

func _on_disable_prompts_button_toggled(toggled_on: bool) -> void:
	GameManager.disable_prompts = toggled_on

func _on_delete_data_button_pressed() -> void:
	sfx_player.play_sfx(button_press_sfx)
	confirmation_popup_overlay.visible = true
	cancel_button.grab_focus()

func _on_back_button_pressed() -> void:
	sfx_player.play_sfx(button_press_sfx)
	save_settings()
	await get_tree().create_timer(0.1).timeout
	get_tree().change_scene_to_file(Constants.TITLE_SCREEN)

func _on_confirm_button_pressed() -> void:
	sfx_player.play_sfx(button_press_sfx)
	DirAccess.remove_absolute("user://speedy_shopper_save_file.cfg")
	SaveLoadManager.reset_game_data()
	delete_confirm_label.visible = true
	confirmation_popup_overlay.visible = false

func _on_cancel_button_pressed() -> void:
	sfx_player.play_sfx(button_press_sfx)
	confirmation_popup_overlay.visible = false
	back_button.grab_focus()
