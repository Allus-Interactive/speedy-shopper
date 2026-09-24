extends Control

@onready var sfx_player: SfxPlayer = $SFXPlayer
@onready var days_worked_stat: Label = $DaysWorkedStat
@onready var orders_delivered_stat: Label = $OrdersDeliveredStat
@onready var total_earnings_stat: Label = $TotalEarningsStat

@onready var button_press_sfx: AudioStream = preload("res://assets/sfx/button_press.mp3")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	days_worked_stat.text = str(GameManager.days_worked) + " Days"
	orders_delivered_stat.text = str(GameManager.orders_delivered) + " Orders"
	total_earnings_stat.text = "£" + "%0.2f" % GameManager.daily_earnings


func _on_back_button_pressed() -> void:
	sfx_player.play_sfx(button_press_sfx)
	await get_tree().create_timer(0.1).timeout
	get_tree().change_scene_to_file(Constants.TITLE_SCREEN)
