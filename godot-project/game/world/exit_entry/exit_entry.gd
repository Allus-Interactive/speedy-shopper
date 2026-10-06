extends StaticBody3D

class_name ExitEntry

@export var is_in_shop: bool = true

@onready var sfx_player: SfxPlayer = $SFXPlayer

@onready var shop_door: AudioStream = preload("res://assets/sfx/shop_door_bell.mp3")

func show_input_prompt(prompt: InputPrompt) -> void:
	if TutorialManager.tutorial_enabled and TutorialManager.current_step != TutorialManager.Step.COMPLETE:
		prompt.display_prompt("none", "Please complete the Tutorial\nbefore leaving")
	else:
		if is_in_shop:
			prompt.display_prompt("interact", "Leave")
		else:
			prompt.display_prompt("interact", "Enter")

func interact(_p: Player) -> void:
	if TutorialManager.tutorial_enabled:
		if TutorialManager.current_step == TutorialManager.Step.COMPLETE:
			TutorialManager.next_step()
			get_tree().change_scene_to_file(Constants.TITLE_SCREEN)
			# TODO: clean order after tutorial
			OrderManager.active_order = null
			OrderManager.active_delivery = null
	else:
		if is_in_shop:
			sfx_player.play_sfx(shop_door)
			await get_tree().create_timer(0.25).timeout
			GameManager.previous_scene = "Shop"
			GameManager.thread_load_scene(Constants.DRIVING_SCENE)
			
		else:
			# Remove time constraints on shop entry, reintroduce with day/night cycle
			#if GameTimeManager.hour >= 10 and GameTimeManager.hour <= 22:
			sfx_player.play_sfx(shop_door)
			# store player position
			GameManager.player_position = self.global_position
			GameManager.player_rotation = self.global_rotation
			await get_tree().create_timer(0.25).timeout
			GameManager.thread_load_scene(Constants.SHOP_SCENE)
