extends Button

class_name ItemLabel

@onready var label_background: ColorRect = $LabelBackground
@onready var product_label: Label = $LabelBackground/ProductLabel
@onready var quantity_label: Label = $LabelBackground/QuantityLabel

func _ready() -> void:
	pass

func populate_data(product_name: String, required_qty: int, scanned_qty: int) -> void:
	product_label.text = str(required_qty) + "x " + product_name
	quantity_label.text = "%d/%d Items Picked" % [scanned_qty, required_qty]
	
	if scanned_qty >= required_qty:
		label_background.color = Color.GRAY
	else:
		label_background.color = Color.TRANSPARENT
