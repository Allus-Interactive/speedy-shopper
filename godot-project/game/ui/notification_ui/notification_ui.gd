extends CanvasLayer

class_name NotificationUI

@onready var notification_panel: ColorRect = $NotificationPanel
@onready var notification_label: Label = $NotificationPanel/NotificationLabel

func _ready() -> void:
	notification_panel.visible = false
	GameManager.notification_ui = self

func show_message(ui_text: String, is_success: bool) -> void:
	if is_success:
		#notification_panel.color = Color.CHARTREUSE
		notification_label.add_theme_color_override("font_color", Color.FOREST_GREEN)
	else:
		#notification_panel.color = Color.DARK_RED
		notification_label.add_theme_color_override("font_color", Color.DARK_RED)
		
	notification_label.text = ui_text
	notification_panel.visible = true
	
	await get_tree().create_timer(3.0).timeout
	
	notification_panel.visible = false
	notification_label.text = ""
