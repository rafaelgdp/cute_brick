extends Area2D

var wait_hit = true

signal recharge

func _ready():
	$"../../shoot".connect("empty" , self , "on_empty")

func hit_bottom(node):
	if wait_hit == true:
		$"../../shoot".position = node.position
		wait_hit = false
	node.queue_free()
	pass

func on_empty(cartridge):
	print(wait_hit)
	emit_signal("recharge")
