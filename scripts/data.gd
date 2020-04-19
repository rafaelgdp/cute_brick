extends Node

const FILE_NAME = "user://game_data.json"

var game = {
	"high_score" : 0,
	"sound" : 
		{
			"fx" : 9,
			"fx_vol" : 0,
			"music" : 9,
			"music_vol" : 0
		}
}

func save_game():
	var file = File.new()
	file.open(FILE_NAME , File.WRITE)
	file.store_string(to_json(game))
	file.close()

func load_game():
	var file = File.new()
	if file.file_exists(FILE_NAME):
		file.open(FILE_NAME , File.READ)
		var data = parse_json(file.get_as_text())
		file.close()
		if typeof(data) == TYPE_DICTIONARY:
			game = data
		else:
			printerr("Corrupted data!")
			
	else:
		printerr("No saved data!")
