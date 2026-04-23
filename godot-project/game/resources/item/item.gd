extends Resource

class_name Item

@export var product_name: String
@export var barcode_value: int
@export var product_price: float = 0
@export var product_type: CATEGORY

enum CATEGORY { BEER, BREAD, CEREAL, CRISPS, FIZZY_DRINK, MILK, SPIRITS, TINNED_FOOD, WINE, CONDIMENTS, MEAT, FRESH, MEAL_KITS, PASTA_RICE, COOKING_SAUCES }

# TODO: implement into CATEGORY 
# { MEAT, FRESH, PASTA_RICE, COOKING_SAUCES, MEAL_KITS }
# Aisle 1, Left Side, in order left to right
# FRESH: cheese, yoghurts, ready meals, deserts etc.
# MEAT: sausages,burgers, steak etc.
# PASTA_RICE: PAsta, Rice, etc. 
# COOKING_SAUCES: Pasta sauce, curry sauce etc.
# MEAL_KITS: fajita kit, enchilada kit, taco kit etc.
