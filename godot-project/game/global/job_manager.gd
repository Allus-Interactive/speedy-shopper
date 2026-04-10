extends Node

class_name JobManager

signal order_selected

var available_orders: Array[OrderData] = []

func _ready() -> void:
	# Temp set up for available orders
	# TODO: implement auto generation for orders
	var order_1_item_1 := OrderItemData.new()
	order_1_item_1.product_name = "Own Brand Cereal"
	order_1_item_1.barcode_value = 1
	order_1_item_1.required_quantity = 1
	
	var order_1_item_2 := OrderItemData.new()
	order_1_item_2.product_name = "Standard Cereal"
	order_1_item_2.barcode_value = 2
	order_1_item_2.required_quantity = 2
	
	var order_1_item_3 := OrderItemData.new()
	order_1_item_3.product_name = "Finest Cereal"
	order_1_item_3.barcode_value = 3
	order_1_item_3.required_quantity = 2
	
	var order := OrderData.new()
	order.shop_name = "ScotMid"
	order.order_id = 1
	order.items = [order_1_item_1, order_1_item_3]
	order.delivery_address = "Pickup"
	order.customer = "Monkey D Luffy"
	order.order_placed = "10:00"
	order.delivery_time = "11:00"
	order.reward = 10
	
	available_orders.append(order)
	
	var order_2_item_1 := OrderItemData.new()
	order_2_item_1.product_name = "Standard Cereal"
	order_2_item_1.barcode_value = 2
	order_2_item_1.required_quantity = 2
	
	var order_2_item_2 := OrderItemData.new()
	order_2_item_2.product_name = "Own Brand Cereal"
	order_2_item_2.barcode_value = 1
	order_2_item_2.required_quantity = 1
	
	var order_2 := OrderData.new()
	order_2.shop_name = "ScotMid"
	order_2.order_id = 2
	order_2.items = [order_2_item_1, order_2_item_2]
	order_2.delivery_address = "Pickup"
	order_2.customer = "Bruce Wayne"
	order_2.order_placed = "11:00"
	order_2.delivery_time = "12:00"
	order_2.reward = 15

	available_orders.append(order_2)
	
	var order_3_item_1 := OrderItemData.new()
	order_3_item_1.product_name = "Own Brand Cereal"
	order_3_item_1.barcode_value = 1
	order_3_item_1.required_quantity = 1
	
	var order_3 := OrderData.new()
	order_3.shop_name = "ScotMid"
	order_3.order_id = 3
	order_3.items = [order_3_item_1]
	order_3.delivery_address = "Pickup"
	order_3.customer = "Tony Stark"
	order_3.order_placed = "13:00"
	order_3.delivery_time = "14:00"
	order_3.reward = 25
	
	available_orders.append(order_3)

func select_order_by_id(id: int) -> void:
	for order in available_orders:
		if order.order_id == id:
			var items = order.items
			TheOrderManager.active_order = order
			TheOrderManager.no_of_unique_items_in_order = items.size()
			order_selected.emit()
	# TODO: Handle order not found?
