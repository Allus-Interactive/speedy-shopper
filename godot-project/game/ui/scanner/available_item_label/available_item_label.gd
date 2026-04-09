extends Button

class_name AvailableItemLabel

@onready var order_label: Label = $LabelBackground/OrderLabel
@onready var quantity_label: Label = $LabelBackground/QuantityLabel

var order_id: int = 0

func _ready() -> void:
	self.focus_mode = Control.FOCUS_ALL

func populate_data(order_number: int, item_qty: int) -> void:
	order_id = order_number
	order_label.text = "Order #" + str(order_number).pad_zeros(5)
	# TODO: Must be a better way to handle this?!
	if item_qty == 1:
		quantity_label.text = str(item_qty) + " Item"
	else:
		quantity_label.text = str(item_qty) + " Items"

func focus_on_button() -> void:
	self.grab_focus()

func _pressed() -> void:
	print("You pressed a button!")
	TheJobManager.select_order_by_id(order_id)
