extends StaticBody3D

class_name ProductPlaceholder

var product_data: Product
var mesh_instance: MeshInstance3D

@onready var collision_shape: CollisionShape3D = $CollisionShape3D
@onready var visual_root: Node3D = $VisualRoot
@onready var label_3d: Label3D = $Label3D
@onready var barcode_root: Node3D = $BarcodeRoot
@onready var barcode_marker: Marker3D = $BarcodeMarker

func interact(player: Player) -> void:
	player.pick_up_product(self)


func set_product_data(data: Product) -> void:
	product_data = data
	_rebuild()

func _rebuild() -> void:
	if mesh_instance:
		mesh_instance.queue_free()
		mesh_instance = null
	
	if product_data == null:
		return
	
	var size := product_data.placeholder_size
	
	var box := BoxMesh.new()
	box.size = size
	
	var material := StandardMaterial3D.new()
	material.albedo_color = product_data.product_colour
	box.material = material
	
	mesh_instance = MeshInstance3D.new()
	mesh_instance.mesh = box
	visual_root.add_child(mesh_instance)
	
	var shape := BoxShape3D.new()
	shape.size = size
	collision_shape.shape = shape
	
	# TODO: improve label placement
	_setup_label(size)
	_setup_barcode(size)
	
	position = product_data.shelf_offset
	rotation_degrees = product_data.shelf_rotation_degrees

func _setup_barcode(size: Vector3) -> void:
	for child in barcode_root.get_children():
		child.queue_free()
	
	if product_data == null:
		return
	
	var plane = MeshInstance3D.new()
	var quad = QuadMesh.new()
	
	quad.size = product_data.barcode_size
	plane.mesh = quad
	
	var material = StandardMaterial3D.new()
	material.albedo_color = Color.WHITE
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.cull_mode = BaseMaterial3D.CULL_DISABLED
	plane.material_override = material
	
	barcode_root.add_child(plane)
	
	# Put barcode on the back of the box
	barcode_root.position = Vector3(
		product_data.barcode_offset.x,
		product_data.barcode_offset.y,
		-(size.z * 0.5) - 0.001 + product_data.barcode_offset.z
	)
	
	# Make the plane face outward from the back face
	barcode_root.rotation_degrees = Vector3(0, 180, 0)
	
	barcode_marker.position = barcode_root.position
	barcode_marker.rotation_degrees = barcode_root.rotation_degrees

func _setup_label(size: Vector3) -> void:
	label_3d.text = product_data.product_name
	
	# Put the label near the front face of the box
	label_3d.position = Vector3(
		0,
		0,
		(size.z * 0.5) + 0.01
	)
