extends CanvasLayer

class_name ScannerUI

@export var closed_y: float = 1080.0
@export var open_y: float = 150.0
@export var slide_duration: float = 0.5

@onready var scanner_container: TextureRect = $ScannerContainer
# View Containers
@onready var current_order_view: MarginContainer = $ScannerContainer/Screen/CurrentOrderView
@onready var available_orders_view: MarginContainer = $ScannerContainer/Screen/AvailableOrdersView
@onready var deliveries_view: MarginContainer = $ScannerContainer/Screen/DeliveriesView
# Current Order View
@onready var title_label: Label = $ScannerContainer/Screen/CurrentOrderView/VBoxContainer/TitleLabel
@onready var order_details_container: HBoxContainer = $ScannerContainer/Screen/CurrentOrderView/VBoxContainer/OrderDetailsContainer
@onready var delivery_details: Label = $ScannerContainer/Screen/CurrentOrderView/VBoxContainer/OrderDetailsContainer/VBoxDelivery/DeliveryDetails
@onready var time_ordered: Label = $ScannerContainer/Screen/CurrentOrderView/VBoxContainer/OrderDetailsContainer/VBoxDelivery/TimeOrdered
@onready var time_due: Label = $ScannerContainer/Screen/CurrentOrderView/VBoxContainer/OrderDetailsContainer/VBoxDelivery/TimeDue
@onready var customer_details: Label = $ScannerContainer/Screen/CurrentOrderView/VBoxContainer/OrderDetailsContainer/VBoxCustomer/CustomerDetails
@onready var scroll_container: ScrollContainer = $ScannerContainer/Screen/CurrentOrderView/VBoxContainer/ScrollContainer
@onready var items_list: VBoxContainer = $ScannerContainer/Screen/CurrentOrderView/VBoxContainer/ScrollContainer/ItemsList
# Available Orders View
@onready var available_items_list: VBoxContainer = $ScannerContainer/Screen/AvailableOrdersView/VBoxContainer/AvailableOrdersScroll/AvailableItemsList
# Deliveries View
@onready var deliveries_list: VBoxContainer = $ScannerContainer/Screen/DeliveriesView/VBoxContainer/DeliveriesScroll/DeliveriesList

@onready var scanner_theme = preload("res://assets/themes/scanner.tres")

@onready var item_label_scene = preload("res://game/ui/scanner/item_label/item_label.tscn")
@onready var available_item_label_scene = preload("res://game/ui/scanner/available_item_label/available_item_label.tscn")
@onready var delivery_label_scene = preload("res://game/ui/scanner/delivery_label/delivery_label.tscn")

# Day Time Labels
@onready var day_label: Label = $ScannerContainer/DateTime/DayLabel
@onready var time_label: Label = $ScannerContainer/DateTime/TimeLabel

var is_animating: bool = false

func _ready() -> void:
	GameManager.scroll_container = scroll_container
	scanner_container.position.y = closed_y
	display_available_orders()
	
	if not OrderManager.order_updated.is_connected(display_current_order):
		OrderManager.order_updated.connect(display_current_order)
	
	if not JobManager.order_selected.is_connected(display_current_order):
		JobManager.order_selected.connect(display_current_order)

func _process(_delta: float) -> void:
	time_label.text = GameTimeManager.get_time_string(GameManager.use_24_hour)
	day_label.text = GameTimeManager.get_day_string()

func toggle_scanner() -> void:
	if is_animating:
		return
	
	if GameManager.is_scanner_open:
		close()
	else:
		open()

func open() -> void:
	if GameManager.is_scanner_open:
		return
	
	var order = OrderManager.active_order
	
	var available_orders = JobManager.available_orders.size()
	var picked_orders = JobManager.picked_orders.size()
	
	if order:
		display_current_order()
	elif available_orders == 0 and picked_orders > 0:
		display_orders_to_be_delivered()
	else:
		display_available_orders()
	
	GameManager.is_scanner_open = true
	_animate_to(open_y)

func close() -> void:
	if not GameManager.is_scanner_open:
		return
	
	GameManager.is_scanner_open = false
	_animate_to(closed_y)

func _animate_to(target_y: float) -> void:
	is_animating = true
	
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(scanner_container, "position:y", target_y, slide_duration)
	
	await tween.finished
	is_animating = false

func display_current_order() -> void:
	var order = OrderManager.active_order
	
	if order:
		# show current order view
		current_order_view.visible = true
		available_orders_view.visible = false
		deliveries_view.visible = false
		_build_current_order_view(order)

func display_orders_to_be_delivered() -> void:
	# Show orders to be delivered
	current_order_view.visible = false
	available_orders_view.visible = false
	deliveries_view.visible = true
	_build_deliveries_view()

func display_available_orders() -> void:
	# show available orders list
	current_order_view.visible = false
	available_orders_view.visible = true
	deliveries_view.visible = false
	_build_available_orders_view()
	
	# TODO: investigate if we need this
	#if order.is_empty():
		#_clear_ui()
		#return

func _clear_ui() -> void:
	current_order_view.visible = false
	available_orders_view.visible = true
	
	for child in items_list.get_children():
		child.queue_free()
	
	for child in available_items_list.get_children():
		child.queue_free()

func _build_current_order_view(order: OrderData) -> void:
	title_label.text = "Order #" + str(order.order_id).pad_zeros(5)
	order_details_container.visible = true
	customer_details.text = order.customer
	delivery_details.text = order.delivery_address + " "
	# TODO: reintroduce when implementing Time system
	# time_ordered.text = "Ordered: " + order.order_placed
	# time_due.text = "Due: " + order.delivery_time
	
	_rebuild_items_list(order.items)
	
func _rebuild_items_list(items: Array[OrderItemData]) -> void:
	for child in items_list.get_children():
		child.queue_free()
	
	var button_in_focus: bool = false
	
	for item in items:
		var row: ItemLabel = item_label_scene.instantiate()
		
		var item_name: String = item.product_info.product_name
		var required_qty: int = item.required_quantity
		var scanned_qty: int = item.scanned_quantity
		var price: float = item.product_info.product_price
		
		# Add label to items list
		items_list.add_child(row)
		# populate label data
		row.populate_data(item_name, required_qty, scanned_qty, price)
		
		if not button_in_focus:
			row.focus_on_button()
			button_in_focus = true

func _build_available_orders_view() -> void:
	var orders = JobManager.available_orders
	var unpicked_orders = orders.filter(func(order): return not order.is_completed)
	_rebuild_available_items_list(unpicked_orders)

func _rebuild_available_items_list(items: Array[OrderData]) -> void:
	for child in available_items_list.get_children():
		child.queue_free()
	
	var button_in_focus: bool = false
	
	for item in items:
		var row: AvailableItemLabel = available_item_label_scene.instantiate()
		
		var order_number: int = item.order_id
		var products: Array[OrderItemData] = item.items
		var item_qty: int = products.size()
		var price: float = item.price
		
		# Add label to items list
		available_items_list.add_child(row)
		# populate label data
		row.populate_data(order_number, item_qty, price)
		
		if not button_in_focus:
			row.focus_on_button()
			button_in_focus = true

func _build_deliveries_view() -> void:
	var picked_orders = JobManager.picked_orders
	_rebuild_delivery_list(picked_orders)

func _rebuild_delivery_list(items: Array[OrderData]) -> void:
	for child in deliveries_list.get_children():
		child.queue_free()
	
	var button_in_focus: bool = false
	
	for item in items:
		var row: DeliveryLabel = delivery_label_scene.instantiate()
		
		# Add label to items list
		deliveries_list.add_child(row)
		# populate label data
		row.populate_data(item)
		
		if not button_in_focus:
			row.focus_on_button()
			button_in_focus = true
