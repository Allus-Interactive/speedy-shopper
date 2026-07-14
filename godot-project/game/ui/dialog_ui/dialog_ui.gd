extends CanvasLayer

class_name DialogUI

@onready var dialog_panel: ColorRect = $DialogPanel
@onready var dialog_text: Label = $DialogPanel/DialogText

func _ready() -> void:
	dialog_panel.visible = false
	DialogManager.dialog_ui = self

func set_text(text: String) -> void:
	dialog_text.text = text
