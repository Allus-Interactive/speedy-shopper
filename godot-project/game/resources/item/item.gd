extends Resource

class_name Item

@export var product_name: String
@export var barcode_value: int
@export var product_price: float = 0
@export var product_type: CATEGORY

enum CATEGORY { BEER, BREAD, CEREAL, CRISPS, FIZZY_DRINK, MILK, SPIRITS, TINNED_FOOD, WINE, CONDIMENTS, MEAT, FRESH, MEAL_KITS, PASTA_RICE, COOKING_SAUCES }
