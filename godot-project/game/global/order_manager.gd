extends Node

class_name OrderManager

signal order_updated
signal product_scanned(product_id: String, success: bool)

var active_order: Dictionary = {}

func scan_product(product_id: int) -> bool:
	if active_order.is_empty():
		product_scanned.emit(product_id, false)
		return false
	
	var items: Array =  active_order.get("items", [])
	
	for item in items:
		if item.get("product_id") == product_id:
			var required_qty = item.get("required_quantity")
			var scanned_qty = item.get("scanned_quantity")
			
			if scanned_qty >= required_qty:
				product_scanned.emit(product_id, false)
				return false
			
			item["scanned_quantity"] = scanned_qty + 1
			order_updated.emit()
			product_scanned.emit(product_id, true)
			return true
	
	product_scanned.emit(product_id, false)
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
