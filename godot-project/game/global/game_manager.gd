extends Node

var daily_earnings: float = 0
var player_money: float = 0

var is_scanner_open: bool = false

var crate_hold_point: Marker3D = null
var delivery_crate: DeliveryCrate = null
var scroll_container: ScrollContainer = null

var notification_ui: NotificationUI = null

var tutorial_panel: Panel = null
var tutorial_label: Label = null

var order_id: int = 1

var is_in_game: bool = false

# Settings
var is_paused : bool = false
var music_bus : int = AudioServer.get_bus_index("Music")
var sfx_bus : int = AudioServer.get_bus_index("SFX")
var music_volume : float = 0.0
var sfx_volume : float = 0.0
var use_24_hour : bool = true

func thread_load_scene(scene_id: String) -> void:
	LoadingOverlay.toggle_loading(true)

	# Allow the loading overlay to be drawn.
	await get_tree().process_frame

	# Begin loading the shop scene in the background.
	var error := ResourceLoader.load_threaded_request(scene_id)
	if error != OK:
		push_error("Failed to start loading scene: %s" % scene_id)
		LoadingOverlay.toggle_loading(false)
		return

	# Wait until the scene has finished loading.
	while true:
		var progress: Array = []
		var status := ResourceLoader.load_threaded_get_status(
			scene_id,
			progress
		)

		# update a progress bar if your loading overlay has one.
		LoadingOverlay.set_progress(progress[0] * 100)

		match status:
			ResourceLoader.THREAD_LOAD_LOADED:
				break

			ResourceLoader.THREAD_LOAD_FAILED:
				push_error("Failed to load scene: %s" % scene_id)
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
	var packed_scene := ResourceLoader.load_threaded_get(scene_id)
	if packed_scene == null:
		push_error("Loaded scene was null.")
		LoadingOverlay.toggle_loading(false)
		return
	
	# Switch to the already-loaded scene.
	get_tree().change_scene_to_packed(packed_scene)
