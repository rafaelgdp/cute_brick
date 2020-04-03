extends Area2D

signal recharge

func _ready():
	pass # Replace with function body.

func hit_bottom(node):
	$"../../shoot".position = node.position
	node.queue_free()
	emit_signal("recharge")
	pass

