extends Node

signal order_selected

# TODO: first crack at save data
# Save the order number?
var order_id: int = 1
var available_orders: Array[OrderData] = []
var completed_orders: Array[OrderData] = []

func _ready() -> void:
	generate_order()

func generate_order() -> void:
	var all_products_in_shop: Array[Item] = ProductManager.all_products
	var grouped_products = group_items_by_category(all_products_in_shop)
	var no_of_orders_to_generate = randi_range(1, 4)
	
	for no_of_orders in no_of_orders_to_generate:
		var products_in_order: Array[OrderItemData] = []
		var no_of_categories: int = Item.CATEGORY.size()
		var no_of_items_in_order: int = randi_range(1, no_of_categories)
		
		# Basic Order Generation
		# TODO: change order of grouped_products? So orders don't follow the same patern every time
		for i in no_of_items_in_order:
			var product = grouped_products[i]
			var new_product := OrderItemData.new()
			new_product.product_info = product[randi_range(0, product.size() - 1)]
			new_product.required_quantity = randi_range(1, 3)
			var max_range = products_in_order.size() if products_in_order.size() == 0 else products_in_order.size() - 1
			var index = randi_range(0, max_range)
			products_in_order.insert(index, new_product)
	
		var order := OrderData.new()
		# irrelevant data, remove?
		order.shop_name = "ScotMid"
		order.order_id = order_id
		order.items = products_in_order
		# TODO: get delivery address
		order.delivery_address = "Pickup"
		# TODO: get customer name
		order.customer = "Bruce Wayne"
		# TODO: get times when time system has been implmented
		order.order_placed = "10:00"
		order.delivery_time = "11:00"
		order.price = calculate_order_price(products_in_order)
		
		available_orders.append(order)
		
		order_id += 1
	
	print("Orders: ", available_orders.size())

func select_order_by_id(id: int) -> void:
	for order in available_orders:
		if order.order_id == id:
			var items = order.items
			OrderManager.active_order = order
			OrderManager.no_of_unique_items_in_order = items.size()
			order_selected.emit()
	# TODO: Handle order not found?

func complete_order_by_id(id: int) -> void:
	for i in range(available_orders.size()):
		var order = available_orders[i]
		
		if order.order_id == id:
			completed_orders.append(order)
			available_orders.remove_at(i)
			return
	# TODO: Handle order not found?

func group_items_by_category(items: Array[Item]) -> Dictionary:
	var result := {}
	
	for category in Item.CATEGORY.values():
		result[category] = []
	
	for item in items:
		result[item.product_type].append(item)
	
	return result

func calculate_order_price(items: Array[OrderItemData]) -> float:
	var total_price = 0
	
	for item in items:
		var price = item.product_info.product_price * item.required_quantity
		total_price += price
	
	return total_price
