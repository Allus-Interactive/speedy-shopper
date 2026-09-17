extends Node3D

class_name CustomerHouse

@export var customer_details: Customer
@export var house_number: int

@onready var house_number_label: Label3D = $HouseNumber
@onready var interaction_point: StaticBody3D = $InteractionPoint

func _ready() -> void:
	house_number_label.text = str(house_number)
