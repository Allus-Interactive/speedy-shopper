extends Button

class_name ItemLabel

@onready var label_background: ColorRect = $LabelBackground
@onready var product_label: Label = $LabelBackground/ProductLabel
@onready var quantity_label: Label = $LabelBackground/QuantityLabel

func _ready() -> void:
	self.focus_mode = Control.FOCUS_ALL

func populate_data(product_name: String, required_qty: int, scanned_qty: int, price: float) -> void:
	product_label.text = str(required_qty) + "x " + product_name + calculate_price(price, required_qty)
	quantity_label.text = "%d/%d Items Picked" % [scanned_qty, required_qty]
	
	if scanned_qty >= required_qty:
		label_background.color = Color.GRAY
	else:
		label_background.color = Color.WHITE

func calculate_price(price: float, required_qty: int) -> String:
	var total_price = price * required_qty
	var formatted_price = "%0.2f" % total_price
	var price_string = " (£" + formatted_price + ")"
	return price_string

func focus_on_button() -> void:
	self.grab_focus()

func _pressed() -> void:
	print("Don't do anything atm")
