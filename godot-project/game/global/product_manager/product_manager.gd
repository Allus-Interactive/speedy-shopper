extends Node

@export var all_products: Array[Item] = []

var items_to_restock: Array[ProductPlaceholder] = []

func restock_products() -> void:
	var no_of_products: int = items_to_restock.size()
	var max_range: int = randi_range(no_of_products/2, no_of_products)
	
	items_to_restock.shuffle()
	
	for i in max_range:
		print("Restocking ", items_to_restock[i].product_data.product_info.product_name)
		items_to_restock[i].visible = true
		items_to_restock[i].collision_shape.disabled = false
