extends KinematicBody2D

var ball = preload("res://scenes/ball.tscn")
var velocity = Vector2()
export (int) var init_cartridge = 10
export (int) var cartridge = init_cartridge
var initial_pos = Vector2()
var wait = true

signal empty

func _ready():
	$"../bottom/area".connect("recharge" , self , "on_recharge")

func get_input():
	velocity = Vector2()
	if Input.is_action_just_pressed("ui_shoot"):
		wait = false
		initial_pos = get_global_mouse_position() - $muzzle.global_position
		shoot()

func shoot():
	if cartridge > 0:
		var b = ball.instance()
		b.add_to_group("balls")
		var g = get_tree().get_nodes_in_group("balls")
		var dir = initial_pos
		if dir.length() > 5:
			rotation = dir.angle()
			velocity = move_and_slide(velocity)
		b.start($muzzle.global_position , rotation)
		get_parent().add_child(b)
		cartridge -= 1
		$interval.start()
	if cartridge == 0:
		print("Cartridge: " , cartridge)
		emit_signal("empty")
		$interval.stop()

func _physics_process(delta):
	get_input()

func _on_interval_timeout():
	shoot()

func on_recharge():
	cartridge = init_cartridge
	print("Refill: " , cartridge)
