extends CanvasLayer

var fade_rect: ColorRect

func _ready() -> void:
	layer = 100
	
	# Create a fullscreen black overlay
	fade_rect = ColorRect.new()
	fade_rect.color = Color.BLACK
	fade_rect.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	fade_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	fade_rect.modulate.a = 1.0
	
	add_child(fade_rect)

func fade_in(fade_duration: float) -> void:
	var tween = create_tween()
	tween.tween_property(
		fade_rect,
		"modulate:a",
		0.0,
		fade_duration
	)

func fade_out(fade_duration: float) -> void:
	var tween = create_tween()
	tween.tween_property(
		fade_rect,
		"modulate:a",
		1.0,
		fade_duration
	)
