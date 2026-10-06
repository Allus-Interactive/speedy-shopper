extends CanvasLayer

class_name InputPrompt

@onready var icon: TextureRect = $TooltipPanel/HBoxContainer/Icon
@onready var label: Label = $TooltipPanel/HBoxContainer/Label

var action: String = ""

func _ready() -> void:
	hide_prompt()
	InputManager.input_type_changed.connect(_on_input_type_changed)

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

func _on_input_type_changed(_new_type: InputManager.InputType) -> void:
	_update_icon()
