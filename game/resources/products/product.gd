extends Resource

class_name Product

@export var product_id: String
@export var product_name: String
@export var barcode_value: String
@export var mesh_scene: PackedScene
@export var inspect_rotation_speed: float = 0.01

@export var placeholder_size: Vector3 = Vector3(0.3, 0.3, 0.2)
@export var shelf_rotation_degrees: Vector3 = Vector3.ZERO
@export var shelf_offset: Vector3 = Vector3.ZERO

@export var default_shelf_quantity: int = 4
