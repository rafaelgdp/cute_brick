extends Node2D

var fx_index = AudioServer.get_bus_index("fx")
var fx_volume = AudioServer.get_bus_volume_db(fx_index)
var music_index = AudioServer.get_bus_index("music")
var music_volume = AudioServer.get_bus_volume_db(music_index)
var fx_label = 9
var volume_value = 3

func _ready():
	pass

func _process(delta):
	$fx_label/fx_value.text = str(fx_label)
	$music_label/music_value.text = str(music_volume)

func _on_fx_minus_pressed():
	fx_volume -= volume_value
	AudioServer.set_bus_volume_db(fx_index , fx_volume)
	fx_label -= 1
	if fx_label == 0:
		AudioServer.set_bus_mute(fx_index , true)
	if fx_label < 0:
		fx_label = 0
		fx_volume = -24.0
	$hit.play()

func _on_fx_plus_pressed():
	if AudioServer.is_bus_mute(fx_index):
		AudioServer.set_bus_mute(fx_index , false)
	fx_volume += volume_value
	AudioServer.set_bus_volume_db(fx_index , fx_volume)
	fx_label += 1
	if fx_label > 10:
		fx_label = 10
		fx_volume = 6
	$hit.play()

func _on_back_pressed():
	SIGN.emit_signal("display_menu")
	self.queue_free()
