extends Node

@export var all_products: Array[Item] = []

var items_to_restock: Array[ProductPlaceholder] = []

func restock_products() -> void:
	var no_of_products: int = items_to_restock.size()
	# Use bitshift for halving ints
	# equivalent of /2, but stops int warning
	var min_range: int = no_of_products >> 1
	var max_range: int = randi_range(min_range, no_of_products)
	
	items_to_restock.shuffle()
	
	for i in range(max_range):
		print("Restocking ", items_to_restock[i].product_data.product_info.product_name)
		items_to_restock[i].visible = true
		items_to_restock[i].collision_shape.disabled = false
