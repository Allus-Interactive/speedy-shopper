extends Node

signal order_selected

# TODO: first crack at save data
# Save the order number?
var order_id: int = 1
var available_orders: Array[OrderData] = []
var picked_orders: Array[OrderData] = []
var completed_orders: Array[OrderData] = []

func _ready() -> void:
	generate_order()

func generate_order() -> void:
	var no_of_orders_to_generate = randi_range(1, 4)
	# Get all products
	var all_products_in_shop: Array[Item] = ProductManager.all_products
	# group by category
	var grouped_products = group_items_by_category(all_products_in_shop)
	# extract into an array and shuffle
	var all_products = grouped_products.values()
	all_products.shuffle()
	
	for no_of_orders in no_of_orders_to_generate:
		var products_in_order: Array[OrderItemData] = []
		var no_of_categories: int = Item.CATEGORY.size()
	# TODO: remove temp testing logic
		var no_of_items_in_order: int = randi_range(1, no_of_categories)
		#var no_of_items_in_order: int = randi_range(1, 2)
		
		# Basic Order Generation
		for i in no_of_items_in_order:
			var product = all_products[i]
			var new_product := OrderItemData.new()
			new_product.product_info = product[randi_range(0, product.size() - 1)]
			new_product.required_quantity = randi_range(1, 3)
			products_in_order.append(new_product)
		
		# Shuffle item order to appear more random
		products_in_order.shuffle()
		
		# get customer details
		var all_customers: Array[Customer] = CustomerManager.all_customers
		var customer_index: int = randi_range(0, all_customers.size() - 1)
		var customer_details: Customer = all_customers[customer_index]
		var customer_title: String = Customer.TITLE.keys()[customer_details.title]
		var customer_name: String = customer_title.to_lower().capitalize() + " " + customer_details.first_name + " " + customer_details.last_name
		
		var order := OrderData.new()
		# irrelevant data, remove?
		order.shop_name = "ScotMid"
		order.order_id = order_id
		order.items = products_in_order
		order.delivery_address = customer_details.address
		order.customer = customer_name
		# TODO: get times when time system has been implmented
		order.order_placed = "10:00"
		order.delivery_time = "11:00"
		order.price = calculate_order_price(products_in_order)
		
		available_orders.append(order)
		
		order_id += 1
	
	print("Orders: ", available_orders.size())

func generate_tutorial_order() -> void:
	available_orders.clear()
	
	# Get all products
	var tutorial_products: Array[Item] = ProductManager.tutorial_products
	# group by category
	var grouped_products = group_items_by_category(tutorial_products)
	# extract into an array
	var all_products = grouped_products.values()
	all_products = all_products.filter(func(a): return !a.is_empty())
	
	var products_in_order: Array[OrderItemData] = []
	
	var no_of_items_in_order: int = 4
	
	# Basic Order Generation
	for i in no_of_items_in_order:
		var product = all_products[i]
		var new_product := OrderItemData.new()
		new_product.product_info = product[randi_range(0, product.size() - 1)]
		new_product.required_quantity = 1
		products_in_order.append(new_product)
	
	# get customer details
	var all_customers: Array[Customer] = CustomerManager.tutorial_customers
	var customer_details: Customer = all_customers[0]
	var customer_title: String = Customer.TITLE.keys()[customer_details.title]
	var customer_name: String = customer_title.to_lower().capitalize() + " " + customer_details.first_name + " " + customer_details.last_name
	
	var order := OrderData.new()
	# irrelevant data, remove?
	order.shop_name = "ScotMid"
	order.order_id = 0
	order.items = products_in_order
	order.delivery_address = customer_details.address
	order.customer = customer_name
	# TODO: get times when time system has been implmented
	order.order_placed = "10:00"
	order.delivery_time = "11:00"
	order.price = calculate_order_price(products_in_order)
	
	available_orders.append(order)
	
	print("Orders: ", available_orders.size())

func select_order_by_id(id: int) -> void:
	for order in available_orders:
		if order.order_id == id:
			var items = order.items
			OrderManager.active_order = order
			OrderManager.no_of_unique_items_in_order = items.size()
			order_selected.emit()
	# TODO: Handle order not found?

func pick_order_by_id(id: int) -> void:
	for i in range(available_orders.size()):
		var order = available_orders[i]
		
		if order.order_id == id:
			picked_orders.append(order)
			available_orders.remove_at(i)
			return
	# TODO: Handle order not found?

func complete_order_by_id(id: int) -> void:
	for i in range(available_orders.size()):
		var order = available_orders[i]
		
		if order.order_id == id:
			completed_orders.append(order)
			available_orders.remove_at(i)
			return
	# TODO: Handle order not found?

func complete_delivery_by_id(id: int) -> void:
	for i in range(picked_orders.size()):
		var order = picked_orders[i]
		
		if order.order_id == id:
			completed_orders.append(order)
			picked_orders.remove_at(i)
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
