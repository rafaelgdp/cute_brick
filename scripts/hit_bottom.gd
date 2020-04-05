extends Area2D

var wait_hit = true

signal recharge(waiting)

func _ready():
	pass

func hit_bottom(node):
	if wait_hit == true:
		$"../../shoot_sprite".position = node.position
		wait_hit = false
	node.queue_free()
	var g = get_tree().get_nodes_in_group("balls")
	if g.size() == 1:
		$"../../shoot".position = Vector2(node.position.x , 630)
		wait_hit = true
		emit_signal("recharge" , true)
