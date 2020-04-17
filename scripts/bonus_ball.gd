extends Area2D

func collect(node):
	SIGN.emit_signal("add_ball")
	get_parent().queue_free()

func _process(delta):
	if self.global_position.y >= 464:
		SIGN.emit_signal("remove_ball")
		get_parent().queue_free()
