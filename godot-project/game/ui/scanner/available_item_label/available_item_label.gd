extends ColorRect

class_name AvailableItemLabel

@onready var order_label: Label = $OrderLabel
@onready var quantity_label: Label = $QuantityLabel

func _ready() -> void:
	pass

func populate_data(order_number: int, item_qty: int) -> void:
	order_label.text = "Order #" + str(order_number).pad_zeros(5)
	# TODO: Must be a better way to handle this?!
	if item_qty == 1:
		quantity_label.text = str(item_qty) + " Item"
	else:
		quantity_label.text = str(item_qty) + " Items"
