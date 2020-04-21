extends Node2D

func _process(delta):
	pass

func _on_back_pressed():
	SIGN.emit_signal("display_menu")
	self.queue_free()

func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST:
		get_tree().change_scene("res://scenes/title.tscn")
