extends Resource

class_name OrderItemData

@export var product_info: Item
@export var required_quantity: int = 1
@export var scanned_quantity: int = 0
@export var product_price: float = 0
@export var product_type: CATERGORY

enum CATERGORY { MILK, CEREAL, CRISPS, FIZZY_DRINK, BEER, WINE, RUM }
