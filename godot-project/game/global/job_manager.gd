extends Node

class_name JobManager

var available_orders: Array = [
	{
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
	},
	{
		"shop_name": "ScotMid",
		"order_id": 2,
		"items": [
			{ "product_id": 1, "product_name": "Own Brand Cereal", "barcode_value": 1, "required_quantity": 2, "scanned_quantity": 0 },
			{ "product_id": 2, "product_name": "Standard Cereal", "barcode_value": 2, "required_quantity": 1, "scanned_quantity": 0 },
		],
		"delivery_address": "Pickup",
		"customer": "Zoro",
		"order_placed": "10:30",
		"delivery_time": "12:00",
		"reward": 15
	},
	{
		"shop_name": "ScotMid",
		"order_id": 3,
		"items": [
			{ "product_id": 3, "product_name": "Finest Cereal", "barcode_value": 3, "required_quantity": 3, "scanned_quantity": 0 }
		],
		"delivery_address": "Pickup",
		"customer": "Nami",
		"order_placed": "13:00",
		"delivery_time": "13:30",
		"reward": 10
	},
]

func select_order_by_id(id: int) -> void:
	for order in available_orders:
		if order.get("order_id") == id:
			TheOrderManager.active_order = order
	# TODO: Handle order not found?
