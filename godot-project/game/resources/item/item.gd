extends Resource

class_name Item

@export var product_name: String
@export var barcode_value: int
@export var product_price: float = 0
@export var product_type: CATERGORY

enum CATERGORY { BEER, BREAD, CEREAL, CRISPS, FIZZY_DRINK, MILK, RUM, TINNED_FOOD, WINE }
