extends Button

class_name ItemLabel

@onready var label_background: ColorRect = $LabelBackground
@onready var product_label: Label = $LabelBackground/ProductLabel
@onready var quantity_label: Label = $LabelBackground/QuantityLabel
@onready var unavailable_label: Label = $LabelBackground/UnavailableLabel

var current_item_name: String
var required_quantity: int = 0

func _ready() -> void:
	self.focus_mode = Control.FOCUS_ALL
	unavailable_label.visible = false

func populate_data(product_name: String, required_qty: int, scanned_qty: int, price: float) -> void:
	current_item_name = product_name
	set_availibility()
	
	render_label_display(required_qty, scanned_qty, price)

func render_label_display(required_qty: int, scanned_qty: int, price: float) -> void:
	product_label.text = str(required_qty) + "x " + current_item_name + calculate_price(price, required_qty)
	quantity_label.text = "%d/%d Items Picked" % [scanned_qty, required_qty]
	
	label_background.color = Color.TRANSPARENT
	if scanned_qty >= required_qty:
		self.disabled = true

func calculate_price(price: float, required_qty: int) -> String:
	var total_price = price * required_qty
	var formatted_price = "%0.2f" % total_price
	var price_string = " (£" + formatted_price + ")"
	return price_string

func focus_on_button() -> void:
	self.grab_focus()

func set_availibility() -> void:
	for item in OrderManager.active_order.items:
		if item.product_info.product_name == current_item_name:
			if item.is_unavailable:
				unavailable_label.visible = true

func _pressed() -> void:
	for item in OrderManager.active_order.items:
		if item.product_info.product_name == current_item_name:
			if item.scanned_quantity == 0 and not item.is_unavailable:
				item.is_unavailable = true
				unavailable_label.visible = true
				item.required_quantity = 0
				render_label_display(item.required_quantity, item.scanned_quantity, item.product_info.product_price)
				if OrderManager.is_active_order_fully_picked():
					OrderManager.active_order.set("is_picked", true)
				if TutorialManager.current_step == TutorialManager.Step.PICK_THIRD_ITEM:
					TutorialManager.next_step()
