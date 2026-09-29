extends Control

@export var display_spinner_label: bool = false

@onready var label: Label = $Label

func _ready() -> void:
	label.visible = display_spinner_label
