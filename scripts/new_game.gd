extends Node2D

onready var new_game_label = $game_over_label/new_game/new_game_label

func _ready():
	SIGN.connect("clear_screen" , self , "on_clear_screen")

func _on_new_game_label_mouse_entered():
	new_game_label.add_color_override("font_color" , Color(1,0,0,1))
	new_game_label.add_color_override("font_outline_modulate" , Color(0.35,0,0,1))

func _on_new_game_label_mouse_exited():
	new_game_label.add_color_override("font_color" , Color(1,1,1,1))
	new_game_label.add_color_override("font_outline_modulate" , Color(0.35,0.35,0.35,1))

func on_clear_screen():
	self.queue_free()

func _on_new_game_button_up():
	SIGN.emit_signal("new_game")
