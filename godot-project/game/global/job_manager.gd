extends Node

class_name JobManager

signal order_selected

var available_orders: Array[OrderData] = []

func _ready() -> void:
	# Temp set up for available orders
	# TODO: implement auto generation for orders
	
	var order_1_item_1 := OrderItemData.new()
	var order_1_product_info := Item.new()
	
	order_1_product_info.product_name = "Finest Cereal"
	order_1_product_info.barcode_value = 3
	
	order_1_item_1.product_info = order_1_product_info
	order_1_item_1.required_quantity = 2
	order_1_item_1.product_price = 2.50
	order_1_item_1.product_type = OrderItemData.CATERGORY.CEREAL
	
	var order := OrderData.new()
	order.shop_name = "ScotMid"
	order.order_id = 1
	order.items = [order_1_item_1]
	order.delivery_address = "Pickup"
	order.customer = "Bruce Wayne"
	order.order_placed = "10:00"
	order.delivery_time = "11:00"
	order.price = 5
	
	available_orders.append(order)

func select_order_by_id(id: int) -> void:
	for order in available_orders:
		if order.order_id == id:
			var items = order.items
			TheOrderManager.active_order = order
			TheOrderManager.no_of_unique_items_in_order = items.size()
			order_selected.emit()
	# TODO: Handle order not found?
