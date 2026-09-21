extends Node3D

class_name DirectionalArrow

var target_pos: Vector3 = Vector3.ZERO

func _ready() -> void:
	self.visible = false

func _process(_delta: float) -> void:
	if target_pos != Vector3.ZERO:
		# use self.position for the y co-ordinate to keep arrow level
		# use the following to make the arrow tilt, if adding mulit level terrain
		# look_at(target_pos, Vector3.UP)
		var target: Vector3 = Vector3(target_pos.x, self.position.y, target_pos.z)
		look_at(target, Vector3.UP)

func initialize_arrow() -> void:
	var delivery_address = OrderManager.active_delivery.delivery_address
	var houses = get_tree().get_nodes_in_group("customer_house")
	for house in houses:
		if house is CustomerHouse:
			var house_address = house.customer_details.address
			if delivery_address == house_address:
				self.visible = true
				target_pos = house.global_position
				return

func disable() -> void:
	self.visible = false
