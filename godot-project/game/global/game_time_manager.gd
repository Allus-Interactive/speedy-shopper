extends Node

enum Day {
	MONDAY,
	TUESDAY,
	WEDNESDAY,
	THURSDAY,
	FRIDAY,
	SATURDAY,
	SUNDAY
}

var day : Day = Day.MONDAY
var hour: int = 10
var minute: int = 0

var time_accumulator : float = 0.0
var seconds_per_minute : float = 1.0

func _process(delta: float) -> void:
	time_accumulator += delta
	
	if time_accumulator >= seconds_per_minute:
		time_accumulator -= seconds_per_minute
		advance_minute()

func advance_minute() -> void:
	minute += 1
	
	if minute >= 60:
		minute = 0
		hour += 1
	
	if hour >= 24:
		hour = 0
		advance_day()

func advance_day() -> void:
	day = (day + 1) % 7

func get_time_string(use_24_hour: bool) -> String:
	if use_24_hour:
		return "%02d:%02d" % [hour, minute]
	
	var display_hour : int = hour % 12
	
	if display_hour == 0:
		display_hour = 12
	
	var period : String = "AM" if hour < 12 else "PM"
	
	return "%d:%02d %s" % [display_hour, minute, period]

func get_day_string() -> String:
	var days = [
		"MON",
		"TUE",
		"WED",
		"THU",
		"FRI",
		"SAT",
		"SUN"
	]
	
	return days[day]
