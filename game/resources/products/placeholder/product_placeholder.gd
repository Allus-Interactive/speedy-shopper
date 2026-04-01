extends StaticBody3D

class_name ProductPlaceholder

var product_data: Product
var mesh_instance: MeshInstance3D

@onready var collision_shape: CollisionShape3D = $CollisionShape3D
@onready var visual_root: Node3D = $VisualRoot
@onready var label_3d: Label3D = $Label3D

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
	
	mesh_instance = MeshInstance3D.new()
	mesh_instance.mesh = box
	visual_root.add_child(mesh_instance)
	
	var shape := BoxShape3D.new()
	shape.size = size
	collision_shape.shape = shape
	
	# TODO: improve label placement
	# _setup_label(size)
	
	position = product_data.shelf_offset
	rotation_degrees = product_data.shelf_rotation_degrees

func _setup_label(size: Vector3) -> void:
	label_3d.text = product_data.product_name
	
	# Put the label near the front face of the box
	label_3d.position = Vector3(
		0,
		0,
		(size.z * 0.5) + 0.01
	)
