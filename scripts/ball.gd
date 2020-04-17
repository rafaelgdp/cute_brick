extends KinematicBody2D

export (int) var speed = 800
var velocity = Vector2()
var damage = 1

func _ready():
	SIGN.connect("free_b_node" , self , "on_free_b_node")
	self.add_to_group("balls")

func start(pos , dir):
	rotation = dir
	position = pos
	velocity = Vector2(speed , 0).rotated(rotation)

func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	if collision:
		velocity = velocity.bounce(collision.normal)

func _on_area_area_entered(area):
	if area.has_method("hit"):
		area.hit(damage , self)
	if area.has_method("hit_bottom"):
		area.hit_bottom(self)
	if area.has_method("collect"):
		area.collect(self)

func on_free_b_node(node):
	if node.is_in_group("balls"):
		node.remove_from_group("balls")
		node.queue_free()
	else:
		pass
	var g = get_tree().get_nodes_in_group("balls")
	if g.size() == 0:
		SIGN.emit_signal("recharge" , true)
		SIGN.emit_signal("brick_down")
		SIGN.emit_signal("b_node_freed")
