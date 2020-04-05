extends Area2D

var wait_hit = true

signal recharge(waiting)
signal game_over
signal brick_down

func _ready():
	pass

func hit_bottom(node):
	if wait_hit == true:
		$"../../shoot_sprite".position = Vector2(node.position.x , 630)
		wait_hit = false
	node.queue_free()
	var g = get_tree().get_nodes_in_group("balls")
	if g.size() == 1:
		$"../../shoot".position = Vector2($"../../shoot_sprite".position.x , 630)
		wait_hit = true
		emit_signal("recharge" , true)
		emit_signal("brick_down")

func touch_bottom(node):
	emit_signal("game_over")
