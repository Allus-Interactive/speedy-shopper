extends Node

enum InputType {
	KEYBOARD_MOUSE,
	XBOX,
	PLAYSTATION,
	GENERIC_CONTROLLER
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
	},
	InputType.GENERIC_CONTROLLER: {
		"interact": preload("res://assets/input_icons/xbox/A.svg"),
		"drop": preload("res://assets/input_icons/xbox/B.svg")
	},
}

func get_icon(action: String) -> Texture2D:
	return ICONS[current_input_type].get(action)

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		set_input_type(InputType.KEYBOARD_MOUSE)
	elif event is InputEventMouseButton:
		set_input_type(InputType.KEYBOARD_MOUSE)
	elif event is InputEventJoypadButton:
		if event.pressed:
			detect_controller(event.device)
	elif event is InputEventJoypadMotion:
		if abs(event.axis_value) > 0.5:
			detect_controller(event.device)

func detect_controller(device: int) -> void:
	var joy_name: String = Input.get_joy_name(device).to_lower()
	
	print("Detect Controller: " + joy_name)
	
	if "xbox" in joy_name or "xinput" in joy_name:
		set_input_type(InputType.XBOX)
	elif "playstation" in joy_name \
	or "dualshock" in joy_name \
	or "dualsense" in joy_name:
		set_input_type(InputType.PLAYSTATION)
	else:
		set_input_type(InputType.GENERIC_CONTROLLER)

func set_input_type(new_type: InputType) -> void:
	if current_input_type == new_type:
		return
	
	current_input_type = new_type
	input_type_changed.emit(new_type)
