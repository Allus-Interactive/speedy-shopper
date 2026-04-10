extends Resource

class_name OrderData

@export var shop_name: String = ""
@export var order_id: int = 0
@export var items: Array[OrderItemData] = []
@export var delivery_address: String = ""
@export var customer: String = ""
@export var order_placed: String = ""
@export var delivery_time: String = ""
@export var reward: int = 0
@export var is_picked: bool = false
@export var is_completed: bool = false
