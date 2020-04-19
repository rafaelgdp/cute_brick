extends Node

func print(message):
	if ProjectSettings.get_setting("logging/file_logging/enable_file_logging"):
		# Get datetime to dictionary
		var dt = OS.get_datetime()
		# Format and print with message
		print("%02d:%02d:%02d - " % [dt.hour , dt.minute , dt.second] , message)
	return true
