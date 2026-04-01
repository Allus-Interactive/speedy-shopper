extends Node3D

class_name ShelfUnit

# placeholder product scene
@export var product_placeholder_scene: PackedScene
# List of products set in the inspector
@export var stocked_products: Array[Product] = []

# number of shelves in the unity
@export var shelf_count: int = 4
# vertical space between shelves
@export var shelf_spacing: float = 0.6
# width of the shelves
@export var shelf_width: float = 2.0
# depth of the shelves
@export var shelf_depth: float = 1.0

# height of the bottom shelf from the floor
var bottom_shelf_height: float = 0.3
# height of the sides of the shelf unit
var side_height: float = 2.25
# thickness of the shelves
var board_thickness: float = 0.05
# thickness of the shelf sides
var side_thickness: float = 0.05

# number of products per shelf
@export var slots_per_shelf: int = 4
@export var slot_margin_x: float = 0.15

# product row
@export var row_width: float = 0.6
@export var row_depth_offset: float = 0.0

var generated_root: Node3D
var slot_root: Node3D

func _ready() -> void:
	rebuild()

func rebuild() -> void:
	if generated_root:
		generated_root.queue_free()
	if slot_root:
		slot_root.queue_free()
	
	generated_root = Node3D.new()
	generated_root.name = "GeneratedGeometry"
	add_child(generated_root)
	
	slot_root = Node3D.new()
	slot_root.name = "ProductSlots"
	add_child(slot_root)
	
	_build_sides()
	_build_shelves()
	_build_slots()
	
	populate_products()

func _build_sides() -> void:
	var left_side := MeshInstance3D.new()
	left_side.mesh = _create_box_mesh(side_thickness, side_height, shelf_depth)
	left_side.position = Vector3(-shelf_width * 0.5 + side_thickness * 0.5, side_height * 0.5, 0)
	generated_root.add_child(left_side)
	
	var right_side := MeshInstance3D.new()
	right_side.mesh = _create_box_mesh(side_thickness, side_height, shelf_depth)
	right_side.position = Vector3(shelf_width * 0.5 - side_thickness * 0.5, side_height * 0.5, 0)
	generated_root.add_child(right_side)

func _build_shelves() -> void:
	for i in range(shelf_count):
		var shelf_y = bottom_shelf_height + (i * shelf_spacing)
		
		var shelf_board := MeshInstance3D.new()
		shelf_board.mesh = _create_box_mesh(shelf_width, board_thickness, shelf_depth)
		shelf_board.position = Vector3(0, shelf_y, 0)
		generated_root.add_child(shelf_board)

func _build_slots() -> void:
	for shelf_index in range(shelf_count):
		var shelf_y = bottom_shelf_height + (shelf_index * shelf_spacing)
		
		for slot_index in range(slots_per_shelf):
			var marker := Marker3D.new()
			marker.name = "Shelf_%d_Slot_%d" % [shelf_index, slot_index]
			
			var t := 0.5
			if slots_per_shelf > 1:
				t = float(slot_index) / float(slots_per_shelf - 1)
			
			var min_x = -shelf_width * 0.5 + slot_margin_x
			var max_x = shelf_width * 0.5 - slot_margin_x
			var slot_x = lerp(min_x, max_x, t)
			
			marker.position = Vector3(slot_x, shelf_y, 0)
			slot_root.add_child(marker)

func _create_box_mesh(width: float, height: float, depth: float) -> BoxMesh:
	var box := BoxMesh.new()
	box.size = Vector3(width, height, depth)
	return box

func get_product_slots() -> Array[Marker3D]:
	var slots: Array[Marker3D] = []
	
	if slot_root == null:
		return slots
	
	for child in slot_root.get_children():
		if child is Marker3D:
			slots.append(child)
	
	return slots

func clear_spawned_products() -> void:
	var slots = get_product_slots()
	
	for slot in slots:
		for child in slot.get_children():
			child.queue_free()

func populate_products() -> void:
	if product_placeholder_scene == null:
		push_warning("No product_placeholder_scene assigned on ShelfUnit.")
		return
	
	clear_spawned_products()
	
	var slots := get_product_slots()
	var count = min(slots.size(), stocked_products.size())
	
	for i in range(count):
		var slot := slots[i]
		var product := stocked_products[i]
		
		if product == null:
			continue
		
		spawn_product_row(slot, product)

func spawn_product_row(slot: Marker3D, product: Product) -> void:
	var quantity = max(product.default_shelf_quantity, 1)
	
	for i in range(quantity):
		var placeholder = product_placeholder_scene.instantiate()
		slot.add_child(placeholder)
		
		if placeholder.has_method("set_product_data"):
			placeholder.set_product_data(product)
		
		if placeholder is Node3D:
			var x_offset = 0.0
			
			if quantity > 1:
				var t = float(i) / float(quantity - 1)
				x_offset = lerp(-row_width * 0.6, row_width * 0.6, t)
			
			var product_y = placeholder.position.y
			placeholder.position = Vector3(row_depth_offset, product_y, x_offset)
			placeholder.rotation = Vector3.ZERO
		
