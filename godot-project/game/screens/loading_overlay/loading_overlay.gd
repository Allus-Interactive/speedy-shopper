extends CanvasLayer

@onready var loading_screen: ColorRect = $LoadingScreen
@onready var progress_bar: ProgressBar = $LoadingScreen/ProgressBar

func _ready() -> void:
	toggle_loading(false)

func toggle_loading(is_loading: bool) -> void:
	visible = is_loading

func set_progress(value: float) -> void:
	progress_bar.value = value
