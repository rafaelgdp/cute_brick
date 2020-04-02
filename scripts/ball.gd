extends KinematicBody2D

export (int) var speed = 800
var velocity = Vector2()
var damage = 1

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
		emit_signal("hit_bottom" , self)
		area.hit_bottom(self)
