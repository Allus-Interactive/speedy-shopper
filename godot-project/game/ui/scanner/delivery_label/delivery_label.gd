extends Button

class_name DeliveryLabel

@onready var label_background: ColorRect = $LabelBackground
@onready var address_label: Label = $LabelBackground/AddressLabel
@onready var customer_label: Label = $LabelBackground/CustomerLabel

func _ready() -> void:
	self.focus_mode = Control.FOCUS_ALL

func populate_data(address: String, customer_name: String) -> void:
	address_label.text = address
	customer_label.text = customer_name

func focus_on_button() -> void:
	self.grab_focus()

func _pressed() -> void:
	print("Don't do anything atm")
