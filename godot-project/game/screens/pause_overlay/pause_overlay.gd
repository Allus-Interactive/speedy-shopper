extends CanvasLayer

@onready var sfx_player: SfxPlayer = $SFXPlayer

@onready var button_press_sfx: AudioStream = preload("res://assets/sfx/button_press.mp3")

func _ready() -> void:
	visible = false
	# keep this node's logic running even when the game tree is paused
	process_mode = Node.PROCESS_MODE_ALWAYS

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause") and GameManager.is_in_game:
		PauseOverlay.toggle_pause(GameManager.is_paused)

func toggle_pause(is_paused: bool) -> void:
	GameManager.is_paused = !is_paused
	visible = !is_paused
	get_tree().paused = !is_paused

func _on_resume_button_pressed() -> void:
	sfx_player.play_sfx(button_press_sfx)
	toggle_pause(GameManager.is_paused)

func _on_menu_button_pressed() -> void:
	sfx_player.play_sfx(button_press_sfx)
	await get_tree().create_timer(0.1).timeout
	toggle_pause(GameManager.is_paused)
	get_tree().change_scene_to_file(Constants.TITLE_SCREEN)
