extends ColorRect

class_name ItemLabel

@onready var item_label: ColorRect = $"."
@onready var product_label: Label = $ProductLabel
@onready var quantity_label: Label = $QuantityLabel

func _ready() -> void:
	pass

func populate_data(product_name: String, required_qty: int, scanned_qty: int) -> void:
	product_label.text = product_name
	quantity_label.text = "%d/%d" % [scanned_qty, required_qty]
	
	if scanned_qty >= required_qty:
		item_label.color = Color.GRAY
	else:
		item_label.color = Color.TRANSPARENT
