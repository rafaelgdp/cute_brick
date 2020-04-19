extends Node2D

var go_sound = preload("res://scenes/sound_menu.tscn")
var go_credits = preload("res://scenes/credits.tscn")

var sound

func _ready():
	SIGN.connect("display_menu" , self , "on_display_menu")
	$play_button.add_to_group("menu_buttons")
	$sound_button.add_to_group("menu_buttons")
	$credits_button.add_to_group("menu_buttons")
	
	DATA.load_game()
	sound = DATA.game["sound"]
	var m_idx = AudioServer.get_bus_index("music")
	AudioServer.set_bus_volume_db(m_idx , sound.music_vol)
	print(sound)
	$theme.play()

func _on_play_button_pressed():
	get_tree().change_scene("res://scenes/game.tscn")

func _on_sound_button_pressed():
	hide_buttons(false)
	var s = go_sound.instance()
#	SIGN.emit_signal("sound_config" , sound)
	get_parent().call_deferred("add_child" , s)

func _on_credits_button_pressed():
	hide_buttons(false)
	var c = go_credits.instance()
	get_parent().call_deferred("add_child" , c)

func hide_buttons(state):
	var menu_display = get_tree().get_nodes_in_group("menu_buttons")
	for i in menu_display:
		i.visible = state

func on_display_menu():
	hide_buttons(true)
