extends Node2D

var fx_index = AudioServer.get_bus_index("fx")
var fx_volume = AudioServer.get_bus_volume_db(fx_index)
var music_index = AudioServer.get_bus_index("music")
var music_volume = AudioServer.get_bus_volume_db(music_index)

var sound_d

var fx_label
var music_label
var volume_value = 3

func _ready():
	DATA.load_game()
	sound_d = DATA.game["sound"]
	print(sound_d)
	fx_label = sound_d.fx
	fx_volume = sound_d.fx_vol
	music_label = sound_d.music
	music_volume = sound_d.music_vol

func _process(delta):
	$fx_label/fx_value.text = str(fx_label)
	$music_label/music_value.text = str(music_label)

func _on_fx_minus_pressed():
	fx_volume -= volume_value
	AudioServer.set_bus_volume_db(fx_index , fx_volume)
	fx_label -= 1
	if fx_label == 0:
		AudioServer.set_bus_mute(fx_index , true)
	if fx_label < 0:
		fx_label = 0
		fx_volume = -24.0
	save_fx()
	DATA.save_game()
	print(sound_d)
	
	$hit.play()

func _on_fx_plus_pressed():
	if AudioServer.is_bus_mute(fx_index):
		AudioServer.set_bus_mute(fx_index , false)
	fx_volume += volume_value
	AudioServer.set_bus_volume_db(fx_index , fx_volume)
	fx_label += 1
	if fx_label > 10:
		fx_label = 10
		fx_volume = 3
	save_fx()
	DATA.save_game()
	print(sound_d)
	
	$hit.play()

func _on_music_minus_pressed():
	music_volume -= volume_value
	AudioServer.set_bus_volume_db(music_index , music_volume)
	music_label -= 1
	if music_label == 0:
		AudioServer.set_bus_mute(music_index , true)
	if music_label < 0:
		music_label = 0
		music_volume = 24.0
	save_music()
	DATA.save_game()
	print(sound_d)

func _on_music_plus_pressed():
	if AudioServer.is_bus_mute(music_index):
		AudioServer.set_bus_mute(music_index , false)
	music_volume += volume_value
	AudioServer.set_bus_volume_db(music_index , music_volume)
	music_label += 1
	if music_label > 10:
		music_label = 10
		music_volume = 3
	save_music()
	DATA.save_game()
	print(sound_d)

func save_fx():
	sound_d.fx = fx_label
	sound_d.fx_vol = fx_volume

func save_music():
	sound_d.music = music_label
	sound_d.music_vol = music_volume

func _on_back_pressed():
	print(sound_d)
	SIGN.emit_signal("display_menu")
	self.queue_free()
