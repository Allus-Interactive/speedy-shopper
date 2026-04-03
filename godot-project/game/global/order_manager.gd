extends Node

class_name OrderManager

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
