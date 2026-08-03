extends Button

class_name DeliveryLabel

@onready var label_background: ColorRect = $LabelBackground
@onready var address_label: Label = $LabelBackground/AddressLabel
@onready var customer_label: Label = $LabelBackground/CustomerLabel

var delivery: OrderData

func _ready() -> void:
	self.focus_mode = Control.FOCUS_ALL

func populate_data(order: OrderData) -> void:
	address_label.text = order.delivery_address
	customer_label.text = order.customer
	delivery = order
	
	label_background.color = Color.TRANSPARENT
	if OrderManager.active_delivery != null:
		if order.order_id == OrderManager.active_delivery.order_id:
			self.disabled = true

func focus_on_button() -> void:
	self.grab_focus()

func _pressed() -> void:
	if OrderManager.active_delivery == null:
		self.disabled = true
		OrderManager.active_delivery = delivery
