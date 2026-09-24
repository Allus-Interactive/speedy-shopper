extends Node

var config = ConfigFile.new()

func _ready() -> void:
	pass 

func save_game_data() -> void:
	config.set_value("stats", "days_worked", GameManager.days_worked)
	config.set_value("stats", "orders_delivered", GameManager.orders_delivered)
	config.set_value("stats", "total_earnings", GameManager.total_earnings)
	config.set_value("money", "daily_earnings", GameManager.daily_earnings)
	config.set_value("time", "hour", GameTimeManager.hour)
	config.set_value("time", "minute", GameTimeManager.minute)
	config.set_value("time", "day", GameTimeManager.day)
	config.set_value("gameplay", "van_position", GameManager.van_position)
	config.set_value("gameplay", "van_rotation", GameManager.van_rotation)
	config.save("user://speedy_shopper_save_file.cfg")

func load_game_data() -> void:
	if config.load("user://speedy_shopper_save_file.cfg") == OK:
		GameManager.days_worked = config.get_value("stats", "days_worked", 0)
		GameManager.orders_delivered = config.get_value("stats", "orders_delivered", 0)
		GameManager.total_earnings = config.get_value("stats", "total_earnings", 0)
		GameManager.daily_earnings = config.get_value("money", "daily_earnings", 0)
		GameTimeManager.hour = config.get_value("time", "hour", 10)
		GameTimeManager.minute = config.get_value("time", "minute", 0)
		GameTimeManager.day = config.get_value("time", "day", 0)
		GameManager.van_position = config.get_value("gameplay", "van_position", 0)
		GameManager.van_rotation = config.get_value("gameplay", "van_rotation", 0)

func reset_game_data() -> void:
	GameManager.days_worked = 0
	GameManager.orders_delivered = 0
	GameManager.total_earnings = 0
	GameManager.daily_earnings = 0
	GameTimeManager.hour = 10
	GameTimeManager.minute = 0
	GameTimeManager.day = 0
	GameManager.van_position = Vector3.ZERO
	GameManager.van_rotation = Vector3.ZERO
