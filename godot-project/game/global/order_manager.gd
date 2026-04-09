extends Node

class_name OrderManager

signal order_updated

var active_order: Dictionary = {}
var no_of_unique_items_in_order: int = 0

func scan_product(product_id: int) -> bool:
	if active_order.is_empty():
		return false
	
	var items: Array =  active_order.get("items", [])
	
	for item in items:
		if item.get("product_id") == product_id:
			var required_qty = item.get("required_quantity")
			var scanned_qty = item.get("scanned_quantity")
			
			if scanned_qty >= required_qty:
				return false
			
			item["scanned_quantity"] = scanned_qty + 1
			order_updated.emit()
			return true
	
	return false

func is_active_order_completed() -> bool:
	if active_order.is_empty():
		return false
	
	for item in active_order.get("items", []):
		var required_qty = item.get("required_quantity")
		var scanned_qty = item.get("scanned_quantity")
		
		if scanned_qty < required_qty:
			return false
	
	return true
