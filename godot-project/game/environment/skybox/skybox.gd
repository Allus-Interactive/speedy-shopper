extends WorldEnvironment

@export var dawn_environment: Environment
@export var day_environment: Environment
@export var evening_environment: Environment
@export var night_environment: Environment

func _ready() -> void:
	update_environment()
	GameTimeManager.hour_changed.connect(update_environment)

func update_environment():
	print("Update the Environment Skybox")
	if GameTimeManager.hour >= 5 and GameTimeManager.hour < 8:
		environment = dawn_environment
	elif GameTimeManager.hour >= 8 and GameTimeManager.hour < 17:
		environment = day_environment
	elif GameTimeManager.hour >= 17 and GameTimeManager.hour < 21:
		environment = evening_environment
	else:
		environment = night_environment
