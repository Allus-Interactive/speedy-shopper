extends Control

class_name TitleScreen

func _on_play_button_pressed() -> void:
	#LoadingOverlay.toggle_loading(true)
	#await get_tree().process_frame
	#get_tree().change_scene_to_file(Constants.SHOP_SCENE)
	
	LoadingOverlay.toggle_loading(true)

	# Allow the loading overlay to be drawn.
	await get_tree().process_frame

	# Begin loading the shop scene in the background.
	var error := ResourceLoader.load_threaded_request(Constants.SHOP_SCENE)
	if error != OK:
		push_error("Failed to start loading scene: %s" % Constants.SHOP_SCENE)
		LoadingOverlay.toggle_loading(false)
		return

	# Wait until the scene has finished loading.
	while true:
		var progress: Array = []
		var status := ResourceLoader.load_threaded_get_status(
			Constants.SHOP_SCENE,
			progress
		)

		# update a progress bar if your loading overlay has one.
		LoadingOverlay.set_progress(progress[0] * 100)

		match status:
			ResourceLoader.THREAD_LOAD_LOADED:
				break

			ResourceLoader.THREAD_LOAD_FAILED:
				push_error("Failed to load scene: %s" % Constants.SHOP_SCENE)
				LoadingOverlay.toggle_loading(false)
				return

		await get_tree().process_frame

	LoadingOverlay.set_progress(64)
	await get_tree().create_timer(0.2).timeout

	LoadingOverlay.set_progress(79)
	await get_tree().create_timer(0.3).timeout

	LoadingOverlay.set_progress(98)
	await get_tree().process_frame

	# Retrieve the loaded PackedScene.
	var packed_scene := ResourceLoader.load_threaded_get(Constants.SHOP_SCENE)
	if packed_scene == null:
		push_error("Loaded scene was null.")
		LoadingOverlay.toggle_loading(false)
		return

	# Switch to the already-loaded scene.
	get_tree().change_scene_to_packed(packed_scene)

func _on_tutorial_button_pressed() -> void:
	TutorialManager.tutorial_enabled = true
	
	LoadingOverlay.toggle_loading(true)

	# Allow the loading overlay to be drawn.
	await get_tree().process_frame

	# Begin loading the shop scene in the background.
	var error := ResourceLoader.load_threaded_request(Constants.SHOP_SCENE)
	if error != OK:
		push_error("Failed to start loading scene: %s" % Constants.SHOP_SCENE)
		LoadingOverlay.toggle_loading(false)
		return

	# Wait until the scene has finished loading.
	while true:
		var progress: Array = []
		var status := ResourceLoader.load_threaded_get_status(
			Constants.SHOP_SCENE,
			progress
		)

		# update a progress bar if your loading overlay has one.
		LoadingOverlay.set_progress(progress[0] * 100)

		match status:
			ResourceLoader.THREAD_LOAD_LOADED:
				break

			ResourceLoader.THREAD_LOAD_FAILED:
				push_error("Failed to load scene: %s" % Constants.SHOP_SCENE)
				LoadingOverlay.toggle_loading(false)
				return

		await get_tree().process_frame

	LoadingOverlay.set_progress(64)
	await get_tree().create_timer(0.2).timeout

	LoadingOverlay.set_progress(79)
	await get_tree().create_timer(0.3).timeout

	LoadingOverlay.set_progress(98)
	await get_tree().process_frame

	# Retrieve the loaded PackedScene.
	var packed_scene := ResourceLoader.load_threaded_get(Constants.SHOP_SCENE)
	if packed_scene == null:
		push_error("Loaded scene was null.")
		LoadingOverlay.toggle_loading(false)
		return

	# Switch to the already-loaded scene.
	get_tree().change_scene_to_packed(packed_scene)
