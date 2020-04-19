extends Node2D


func direct_aim():
	look_at(get_global_mouse_position())

func _process(delta):
	direct_aim()
