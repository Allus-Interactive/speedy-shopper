extends Node

signal order_updated

var active_order: OrderData
var active_delivery: OrderData
var no_of_unique_items_in_order: int = 0

func scan_product(barcode_value: int) -> bool:
	if active_order == null:
		return false
	
	var items: Array[OrderItemData] =  active_order.items
	
	for item in items:
		if item.product_info.barcode_value == barcode_value:
			var required_qty = item.required_quantity
			var scanned_qty = item.scanned_quantity
			
			if scanned_qty >= required_qty:
				return false
			
			item.scanned_quantity = scanned_qty + 1
			order_updated.emit()
			
			if is_active_order_fully_picked():
				active_order.set("is_picked", true)
			
			return true
	
	return false

func is_active_order_fully_picked() -> bool:
	if active_order == null:
		return false
	
	var items: Array[OrderItemData] = active_order.items
	
	if items.is_empty():
		return false
	
	for item in items:
		var required_quantity: int = item.required_quantity
		var scanned_quantity: int = item.scanned_quantity
		
		if scanned_quantity < required_quantity:
			return false
	
	return true
	
