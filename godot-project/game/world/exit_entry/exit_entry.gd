extends StaticBody3D

class_name ExitEntry

@export var is_in_shop: bool = true

@onready var sfx_player: SfxPlayer = $SFXPlayer

@onready var shop_door: AudioStream = preload("res://assets/sfx/shop_door_bell.mp3")

func get_interaction_tooltip(_player: Player) -> String:
	if TutorialManager.tutorial_enabled and TutorialManager.current_step != TutorialManager.Step.COMPLETE:
		return "Please complete the Tutorial\nbefore leaving"
	if GameTimeManager.hour > 22 and GameTimeManager.hour < 10:
		return "The Store is Closed"
	if is_in_shop:
		return "Press E to Leave"
	else:
		return "Press E to Enter"

func interact(_p: Player) -> void:
	if TutorialManager.tutorial_enabled:
		if TutorialManager.current_step == TutorialManager.Step.COMPLETE:
			TutorialManager.next_step()
			get_tree().change_scene_to_file(Constants.TITLE_SCREEN)
	else:
		if is_in_shop:
			sfx_player.play_sfx(shop_door)
			await get_tree().create_timer(0.25).timeout
			GameManager.previous_scene = "Shop"
			GameManager.thread_load_scene(Constants.DRIVING_SCENE)
			
		else:
			if GameTimeManager.hour >= 10 and GameTimeManager.hour <= 22:
				sfx_player.play_sfx(shop_door)
				await get_tree().create_timer(0.25).timeout
				GameManager.thread_load_scene(Constants.SHOP_SCENE)
