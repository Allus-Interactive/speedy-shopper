extends CanvasLayer

class_name InputPrompt

@onready var icon: TextureRect = $TooltipPanel/HBoxContainer/Icon
@onready var label: Label = $TooltipPanel/HBoxContainer/Label

var action: String = ""

func _ready() -> void:
	hide_prompt()

func hide_prompt() -> void:
	self.visible = false

func display_prompt(input_action: String, text: String) -> void:
	action = input_action
	label.text = text
	
	if input_action == "none":
		icon.visible = false
	else:
		icon.visible = true
		_update_icon()
	
	self.visible = true

func _update_icon() -> void:
	icon.texture = InputManager.get_icon(action)
