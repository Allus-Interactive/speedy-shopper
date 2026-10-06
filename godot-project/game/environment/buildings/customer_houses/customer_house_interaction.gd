extends StaticBody3D

@export var customer_house: CustomerHouse

@onready var sfx_player: SfxPlayer = $"../SFXPlayer"

@onready var door_knock: AudioStream = preload("res://assets/sfx/door_knock.mp3")

func show_input_prompt(prompt: InputPrompt) -> void:
	prompt.display_prompt("interact", "Knock")

func interact(player: Player) -> void:
	# TODO: 
	# - create delivery UI - phone showing picked orders to be delivered
	# - select order to deliver, set as active_delivery
	if OrderManager.active_delivery == null:
		GameManager.notification_ui.show_message("You have no active delivery!", false)
		return
	
	var address = customer_house.customer_details.address
	var order_address = OrderManager.active_delivery.delivery_address
	
	if address == order_address:
		GameManager.notification_ui.show_message("Order successfully delivered!", true)
		sfx_player.play_sfx(door_knock)
		await get_tree().create_timer(0.5).timeout
		player.complete_delivery()
	else:
		GameManager.notification_ui.show_message("Wrong Address!", false)

func _order_is_picked() -> bool:
	var active_order = OrderManager.active_order
	if active_order:
		return OrderManager.active_order.is_picked
	return false
