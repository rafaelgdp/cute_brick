extends Node2D

#func _on_play_button_pressed():
#	get_tree().change_scene("res://scenes/game.tscn")

func _on_sound_button_pressed():
	get_tree().change_scene("res://scenes/sound_menu.tscn")


func _on_play_button_button_down():
	get_tree().change_scene("res://scenes/game.tscn")
