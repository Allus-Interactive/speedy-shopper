extends CanvasLayer

class_name InspectionUI

@onready var cursor: Control = $Cursor

func _ready() -> void:
	hide_cursor()

func hide_cursor() -> void:
	self.visible = false

func show_cursor() -> void:
	self.visible = true
	cursor.position = get_viewport().get_visible_rect().size / 2.0
