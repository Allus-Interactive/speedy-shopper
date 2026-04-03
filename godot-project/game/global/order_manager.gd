extends Node

class_name OrderManager

signal order_updated
signal product_scanned(product_id: String, success: bool)

# TODO: remove temp order once order generation is working
var temp_order: Dictionary = {
	"shop_name": "ScotMid",
	"order_id": 1,
	"items": [
		{ "product_id": 1, "product_name": "Own Brand Cereal", "barcode_value": 1, "quantity": 1, "scanned": false },
		{ "product_id": 2, "product_name": "Standard Cereal", "barcode_value": 2, "quantity": 1, "scanned": false },
		{ "product_id": 3, "product_name": "Finest Cereal", "barcode_value": 3, "quantity": 1, "scanned": false }
	],
	"delivery_address": "Pickup",
	"reward": 10
}

var active_order: Dictionary = temp_order # TODO: should be initalized as {}

func scan_product(product_id: int) -> bool:
	if active_order.is_empty():
		product_scanned.emit(product_id, false)
		return false
	
	var items: Array =  active_order.get("items", [])
	
	for item in items:
		if item.get("product_id") == product_id:
			if item.get("scanned", false):
				product_scanned.emit(product_id, false)
				return false
			
			item["scanned"] = true
			order_updated.emit()
			product_scanned.emit(product_id, true)
			return true
	
	product_scanned.emit(product_id, false)
	return false

func is_active_order_completed() -> bool:
	if active_order.is_empty():
		return false
	
	for item in active_order.get("items", []):
		if not item.get("scanned", false):
			return false
	
	return true
