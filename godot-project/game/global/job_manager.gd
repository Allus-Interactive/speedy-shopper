extends Node

class_name JobManager

signal order_selected

# TODO: first crack at save data
# Save the order number?
var order_id: int = 1
var available_orders: Array[OrderData] = []

func _ready() -> void:
	generate_order()

func generate_order() -> void:
	var all_products_in_shop: Array[Item] = ProductManager.all_products
	var products_in_order: Array[OrderItemData] = []
	
	var grouped_products = group_items_by_category(all_products_in_shop)
	
	var milk = grouped_products[Item.CATEGORY.MILK]
	var bread = grouped_products[Item.CATEGORY.BREAD]
	var cereal = grouped_products[Item.CATEGORY.CEREAL]
	var tinned_food = grouped_products[Item.CATEGORY.TINNED_FOOD]
	
	# TODO: implement auto generation for orders
	var new_product := OrderItemData.new()
	new_product.product_info = milk[randi_range(0, milk.size() - 1)]
	new_product.required_quantity = randi_range(1, 3)
	products_in_order.append(new_product)
	var new_product_2 := OrderItemData.new()
	new_product_2.product_info = bread[randi_range(0, bread.size() - 1)]
	new_product_2.required_quantity = randi_range(1, 4)
	products_in_order.append(new_product_2)
	var new_product_3 := OrderItemData.new()
	new_product_3.product_info = cereal[randi_range(0, cereal.size() - 1)]
	new_product_3.required_quantity = randi_range(1, 2)
	products_in_order.append(new_product_3)
	var new_product_4 := OrderItemData.new()
	new_product_4.product_info = tinned_food[randi_range(0, tinned_food.size() - 1)]
	new_product_4.required_quantity = randi_range(1, 5)
	products_in_order.append(new_product_4)
	
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

func select_order_by_id(id: int) -> void:
	for order in available_orders:
		if order.order_id == id:
			var items = order.items
			TheOrderManager.active_order = order
			TheOrderManager.no_of_unique_items_in_order = items.size()
			order_selected.emit()
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
