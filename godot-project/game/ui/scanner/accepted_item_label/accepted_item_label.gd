extends ColorRect

class_name AcceptedItemLabel

@onready var order_label: Label = $OrderLabel

func _ready() -> void:
	pass

func populate_data(order_number: int) -> void:
	order_label.text = "Order #" + str(order_number).pad_zeros(5)
