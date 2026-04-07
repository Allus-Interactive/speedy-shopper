extends Node

class_name OrderManager

signal order_updated
signal product_scanned(product_id: String, success: bool)

# TODO: remove temp order once order generation is working
var temp_order: Dictionary = {
	"shop_name": "ScotMid",
	"order_id": 1,
	"items": [
		{ "product_id": 1, "product_name": "Own Brand Cereal", "barcode_value": 1, "required_quantity": 1, "scanned_quantity": 0 },
		{ "product_id": 2, "product_name": "Standard Cereal", "barcode_value": 2, "required_quantity": 2, "scanned_quantity": 0 },
		{ "product_id": 3, "product_name": "Finest Cereal", "barcode_value": 3, "required_quantity": 3, "scanned_quantity": 0 }
	],
	"delivery_address": "Pickup",
	"customer": "Monkey D Luffy",
	"order_placed": "10:00",
	"delivery_time": "11:30",
	"reward": 10
}

var temp_order_2: Dictionary = {
	"shop_name": "ScotMid",
	"order_id": 2,
	"items": [
		{ "product_id": 1, "product_name": "Own Brand Cereal", "barcode_value": 1, "required_quantity": 2, "scanned_quantity": 0 },
		{ "product_id": 3, "product_name": "Finest Cereal", "barcode_value": 3, "required_quantity": 1, "scanned_quantity": 0 }
	],
	"delivery_address": "Pickup",
	"customer": "Nami",
	"order_placed": "10:30",
	"delivery_time": "11:45",
	"reward": 10
}

var active_order: Dictionary = temp_order # TODO: should be initalized as {}
var accepted_orders: Array = [temp_order, temp_order_2] # TODO: should be initialized as []

func scan_product(product_id: int) -> bool:
	if active_order.is_empty():
		product_scanned.emit(product_id, false)
		return false
	
	var items: Array =  active_order.get("items", [])
	
	for item in items:
		if item.get("product_id") == product_id:
			#var product_name = item.get("product_name")
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
