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
	
	if order.is_ready_for_delivery:
		label_background.color = Color.FOREST_GREEN
	else:
		label_background.color = Color.WHITE

func focus_on_button() -> void:
	self.grab_focus()

func _pressed() -> void:
	for order in JobManager.picked_orders:
		if delivery.order_id == order.order_id:
			order.is_ready_for_delivery = true
	
	label_background.color = Color.FOREST_GREEN
	OrderManager.active_delivery = delivery
