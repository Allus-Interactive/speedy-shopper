extends Node3D

var shelf_width: float = 4.0
var shelf_height: float = 2.0
var shelf_depth: float = 0.4

@export var shelf_levels: int = 4
@export var products_per_level: int = 5
@export var product_placement_offset = 0.25
@export var product_scenes: Array[PackedScene] = []

func _ready() -> void:
	build_shelf()
	place_products()

func build_shelf() -> void:
	# Create the vertical frame (sides)
	for side in [-1, 1]:
		var side_mesh = MeshInstance3D.new()
		side_mesh.mesh = BoxMesh.new()
		side_mesh.scale = Vector3(0.1, shelf_height, shelf_depth)
		side_mesh.position = Vector3((shelf_width / 2 - 0.05) * side, shelf_height / 2, 0)
		add_child(side_mesh)
	
	# Create horizontal shelves
	for i in range(shelf_levels):
		var shelf_y = (i + 1) * (shelf_height / (shelf_levels + 1))
		var shelf_mesh = MeshInstance3D.new()
		shelf_mesh.mesh = BoxMesh.new()
		shelf_mesh.scale = Vector3(shelf_width, 0.05, shelf_depth)
		shelf_mesh.position = Vector3(0, shelf_y, 0)
		add_child(shelf_mesh)

func place_products() -> void:
	if product_scenes.is_empty():
		print("No product scenes provided.")
		return

	for i in range(shelf_levels):
		var shelf_y = (i + 1) * (shelf_height / (shelf_levels + 1)) + product_placement_offset
		# Pick a unique product for this row (e.g., cycle or random)
		var product_index = i % product_scenes.size()  # cycle through
		# Or use: var product_index = randi() % product_scenes.size() for random
		var selected_scene = product_scenes[product_index]
		
		for j in range(products_per_level):
			var product = selected_scene.instantiate()
			var spacing = shelf_width / (products_per_level + 1)
			var x_pos = -shelf_width / 2 + spacing * (j + 1)
			product.position = Vector3(x_pos, shelf_y, 0)
			add_child(product)
