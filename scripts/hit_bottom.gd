extends Area2D

var wait_hit = true

func _ready():
	SIGN.connect("b_node_freed" , self , "on_b_node_freed")

func hit_bottom(node):
	if wait_hit == true:
		$"../../shoot_sprite".position = Vector2(node.position.x , 630)
		wait_hit = false
	SIGN.emit_signal("free_b_node" , node)

func on_b_node_freed():
	var m = get_tree().get_nodes_in_group("muzzle")
	if m.size() == 0:
		pass
	else:
		m[0].position = Vector2($"../../shoot_sprite".position.x , 630)
		wait_hit = true

func touch_bottom(node):
	SIGN.emit_signal("game_over")
	print("wait_hit: " , wait_hit)
