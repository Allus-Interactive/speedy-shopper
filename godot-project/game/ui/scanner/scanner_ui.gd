extends CanvasLayer

class_name ScannerUI

@export var closed_y: float = 1080.0
@export var open_y: float = 450.0
@export var slide_duration: float = 0.5

@onready var scanner_container: TextureRect = $ScannerContainer
@onready var title_label: Label = $ScannerContainer/Screen/MarginContainer/VBoxContainer/TitleLabel
@onready var order_details_container: HBoxContainer = $ScannerContainer/Screen/MarginContainer/VBoxContainer/OrderDetailsContainer
@onready var order_details: Label = $ScannerContainer/Screen/MarginContainer/VBoxContainer/OrderDetailsContainer/VBoxDelivery/OrderDetails
@onready var delivery_details: Label = $ScannerContainer/Screen/MarginContainer/VBoxContainer/OrderDetailsContainer/VBoxDelivery/DeliveryDetails
@onready var customer_details: Label = $ScannerContainer/Screen/MarginContainer/VBoxContainer/OrderDetailsContainer/VBoxCustomer/CustomerDetails
@onready var items_list: VBoxContainer = $ScannerContainer/Screen/MarginContainer/VBoxContainer/ScrollContainer/ItemsList

@onready var scanner_theme = preload("res://assets/themes/scanner.tres")

@onready var item_label_scene = preload("res://game/ui/scanner/item_label/item_label.tscn")

var is_open: bool = false
var is_animating: bool = false

func _ready() -> void:
	scanner_container.position.y = closed_y
	
	if not TheOrderManager.order_updated.is_connected(refresh_from_order):
		TheOrderManager.order_updated.is_connected(refresh_from_order)

func toggle_scanner() -> void:
	if is_animating:
		return
	
	if is_open:
		close()
	else:
		open()

func open() -> void:
	if is_open:
		return
	
	refresh_from_order()
	is_open = true
	_animate_to(open_y)

func close() -> void:
	if not is_open:
		return
	
	is_open = false
	_animate_to(closed_y)

func _animate_to(target_y: float) -> void:
	is_animating = true
	
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(scanner_container, "position:y", target_y, slide_duration)
	
	await tween.finished
	is_animating = false

func refresh_from_order() -> void:
	var order = TheOrderManager.active_order
	#var order = {}
	
	if order.is_empty():
		_clear_ui()
		return
	
	title_label.text = "Order #" + str(order.get("order_id")).pad_zeros(5)
	order_details_container.visible = true
	customer_details.text = order.get("customer")
	order_details.text = "Ordered: " +order.get("order_placed")
	delivery_details.text = "Due:" + order.get("delivery_time")
	
	_rebuild_items_list(order.get("items", []))

func _clear_ui() -> void:
	title_label.text = "No Active Order"
	order_details_container.visible = false
	
	for child in items_list.get_children():
		child.queue_free()

func _rebuild_items_list(items: Array) -> void:
	for child in items_list.get_children():
		child.queue_free()
	
	for item in items:
		var row: ItemLabel = item_label_scene.instantiate()
		
		var item_name: String = item.get("product_name", "Unknown Item")
		var required_qty = item.get("required_quantity")
		var scanned_qty = item.get("scanned_quantity")
		
		# Add label to items list
		items_list.add_child(row)
		# populate label data
		row.populate_data(item_name, required_qty, scanned_qty)
