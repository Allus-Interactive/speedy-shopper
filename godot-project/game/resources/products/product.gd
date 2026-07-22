extends Resource

class_name Product

@export var product_info: Item
@export var inspect_rotation_speed: float = 0.01

@export var placeholder_size: Vector3 = Vector3(0.3, 0.3, 0.2)
@export var shelf_rotation_degrees: Vector3 = Vector3.ZERO
@export var shelf_offset: Vector3 = Vector3.ZERO

@export var default_shelf_quantity: int = 4

@export var label_size: FONT_SIZE = FONT_SIZE.L
@export var product_colour: Color = Color(0.8, 0.8, 0.4)

@export var barcode_size: Vector2 = Vector2(0.12, 0.08)
@export var barcode_offset: Vector3 = Vector3.ZERO

@export var barcode_image: CompressedTexture2D = preload("res://assets/barcodes/barcode.png")

@export var model: PackedScene

enum FONT_SIZE { L, M, S }
