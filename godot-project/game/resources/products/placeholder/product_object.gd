extends StaticBody3D

class_name ProductObject

var product_data: Product
var mesh_instance: MeshInstance3D

@onready var collision_shape: CollisionShape3D = $CollisionShape3D
@onready var visual_root: Node3D = $VisualRoot
@onready var label_3d: Label3D = $Label3D
@onready var barcode_root: Node3D = $BarcodeRoot
@onready var barcode_marker: Marker3D = $BarcodeMarker
@onready var barcode_hitbox: StaticBody3D = $BarcodeHitbox
@onready var barcode_collider: CollisionShape3D = $BarcodeHitbox/BarcodeCollider

func interact(player: Player) -> void:
	player.pick_up_product(self)

func set_product_data(data: Product) -> void:
	product_data = data
	_rebuild()

func get_interaction_tooltip(_player: Player) -> String:
	if product_data == null:
		return "Press E to inspect"
	
	return "%s\nPress E to inspect" % product_data.product_info.product_name

func on_barcode_clicked() -> bool:
	if product_data == null:
		return false
	
	var success = OrderManager.scan_product(product_data.product_info.barcode_value)
	
	if success:
		print("Scanned: ", product_data.product_info.product_name)
		return true
	else:
		print("Failed to scan item or already scanned: ", product_data.product_info.product_name)
		return false

func _rebuild() -> void:
	if mesh_instance:
		mesh_instance.queue_free()
		mesh_instance = null
	
	if product_data == null:
		return
	
	var size := product_data.placeholder_size
	
	if product_data.model:
		var instance = product_data.model.instantiate()
		visual_root.add_child(instance)
	else:		
		var box := BoxMesh.new()
		box.size = size
		
		var material := StandardMaterial3D.new()
		material.albedo_color = product_data.product_colour
		box.material = material
		
		mesh_instance = MeshInstance3D.new()
		mesh_instance.mesh = box
		visual_root.add_child(mesh_instance)
		
		# TODO: Do we want the label on 3D Models? Or should it be part of the model texture?
		_setup_label(size)
	
	# This is needed for either the model or placeholder, as it resizes the collision shape
	var shape := BoxShape3D.new()
	shape.size = size
	collision_shape.shape = shape
	
	_setup_barcode_with_texture(size)
	
	position = product_data.shelf_offset
	rotation_degrees = product_data.shelf_rotation_degrees

func _setup_barcode_with_texture(size: Vector3) -> void:
	for child in barcode_root.get_children():
		child.queue_free()
	
	if product_data == null:
		return
	
	barcode_hitbox.reparent(barcode_root)
	barcode_hitbox.set_meta("is_barcode", true)
	barcode_hitbox.set_meta("owner_product", self)
	
	var plane = MeshInstance3D.new()
	var quad = QuadMesh.new()
	
	quad.size = product_data.barcode_size
	plane.mesh = quad
	
	var material = StandardMaterial3D.new()
	if product_data.barcode_image:
		material.albedo_texture = product_data.barcode_image
	else:
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

func _setup_barcode_with_meshes(size: Vector3) -> void:
	for child in barcode_root.get_children():
		child.queue_free()
	
	if product_data == null:
		return
	
	barcode_hitbox.reparent(barcode_root)
	barcode_hitbox.set_meta("is_barcode", true)
	barcode_hitbox.set_meta("owner_product", self)
	
	barcode_root.position = Vector3(
		product_data.barcode_offset.x,
		product_data.barcode_offset.y,
		-(size.z * 0.5) - 0.001 + product_data.barcode_offset.z
	)
	barcode_root.rotation_degrees = Vector3(0, 180, 0)
	
	barcode_marker.position = barcode_root.position
	barcode_marker.rotation_degrees = barcode_root.rotation_degrees
	
	var bg := MeshInstance3D.new()
	var bg_quad := QuadMesh.new()
	bg_quad.size = product_data.barcode_size
	bg.mesh = bg_quad
	
	var bg_mat := StandardMaterial3D.new()
	bg_mat.albedo_color = Color.WHITE
	bg_mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	bg_mat.cull_mode = BaseMaterial3D.CULL_DISABLED
	bg.material_override = bg_mat
	
	barcode_root.add_child(bg)
	
	var stripe_count := 12
	var total_width := product_data.barcode_size.x
	var stripe_height := product_data.barcode_size.y * 0.85

	for i in range(stripe_count):
		if i % 2 == 0:
			continue
		
		var stripe := MeshInstance3D.new()
		var stripe_quad := QuadMesh.new()
		stripe_quad.size = Vector2(total_width / stripe_count * 0.6, stripe_height)
		stripe.mesh = stripe_quad
		
		var stripe_mat := StandardMaterial3D.new()
		stripe_mat.albedo_color = Color.BLACK
		stripe_mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
		stripe_mat.cull_mode = BaseMaterial3D.CULL_DISABLED
		stripe.material_override = stripe_mat
		
		var x_pos = -total_width * 0.5 + (float(i) + 0.5) * (total_width / stripe_count)
		stripe.position = Vector3(x_pos, 0, -0.0005)
		
		barcode_root.add_child(stripe)

func _setup_label(size: Vector3) -> void:
	label_3d.text = product_data.product_info.product_name
	
	_set_label_font_size()
	
	# Put the label near the front face of the box
	label_3d.position = Vector3(
		0,
		0,
		(size.z * 0.5) + 0.01
	)

func _set_label_font_size() -> void:
	if product_data.label_size == Product.FONT_SIZE.L:
		label_3d.font_size = 64
	elif product_data.label_size == Product.FONT_SIZE.M:
		label_3d.font_size = 48
	elif product_data.label_size == Product.FONT_SIZE.S:
		label_3d.font_size = 32

func disable_barcode_hitbox(disabled: bool) -> void:
	barcode_collider.disabled = disabled
