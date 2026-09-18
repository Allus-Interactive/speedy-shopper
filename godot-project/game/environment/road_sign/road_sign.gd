extends Node3D

@export var road_name: String = "Hawthorne Avenue"

@onready var road_sign_label: Label3D = $RoadSign/RoadSignLabel

func _ready() -> void:
	road_sign_label.text = road_name
