extends Node2D

func _process(delta):
	pass

func _on_back_pressed():
	SIGN.emit_signal("display_menu")
	self.queue_free()
