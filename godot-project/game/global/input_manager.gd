extends Node

enum InputType {
	KEYBOARD_MOUSE,
	XBOX,
	PLAYSTATION
}

var current_input_type: InputType = InputType.KEYBOARD_MOUSE

signal input_type_changed

const ICONS = {
	InputType.KEYBOARD_MOUSE: {
		"interact": preload("res://assets/input_icons/keyboard_mouse/lmb.svg"),
		"drop": preload("res://assets/input_icons/keyboard_mouse/rmb.svg")
	},
	InputType.XBOX: {
		"interact": preload("res://assets/input_icons/xbox/A.svg"),
		"drop": preload("res://assets/input_icons/xbox/B.svg")
	},
	InputType.PLAYSTATION: {
		"interact": preload("res://assets/input_icons/ps/cross.svg"),
		"drop": preload("res://assets/input_icons/ps/circle.svg")
	}
}

func get_icon(action: String) -> Texture2D:
	return ICONS[current_input_type].get(action)
