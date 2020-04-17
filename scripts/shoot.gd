extends KinematicBody2D

# Vars
var ball = preload("res://scenes/ball.tscn")
var velocity = Vector2()
export (int) var init_cartridge = 35
var cartridge = init_cartridge
var initial_pos = Vector2()
var wait = true
var b = null
var g_max:float = 0

func _ready():
	wait = false
	add_to_group("muzzle")
	SIGN.connect("recharge" , self , "on_recharge")
	SIGN.connect("add_ball" , self , "on_add_ball")

func get_input():
	velocity = Vector2()
	var m_input = Input.is_action_just_released("ui_shoot")
	if m_input:
		if wait:
			initial_pos = get_global_mouse_position() - $muzzle.global_position
			wait = false
			if initial_pos.y > -10:
				initial_pos.y = -10
			shoot()
			SIGN.emit_signal("aim" , true)
		else:
			pass

func shoot():
	if cartridge > 0:
		b = ball.instance()
		var dir = initial_pos
		if dir.length() > 5:
			rotation = dir.angle()
			velocity = move_and_slide(velocity)
		b.start($muzzle.global_position , rotation)
		get_parent().call_deferred("add_child" , b)
		cartridge -= 1
		$interval.start()
	if cartridge == 0:
		$interval.stop()
		var g : float = get_tree().get_nodes_in_group("balls").size()
		g_max = g

func _physics_process(delta):
	if wait:
		get_input()
	else:
		pass
	var str_cart = str(cartridge)
	SIGN.emit_signal("update_cartridge" , str_cart)

func _on_interval_timeout():
	shoot()

func on_recharge(waiting):
	cartridge = init_cartridge
	wait = waiting
	SIGN.emit_signal("aim" , false)

func on_add_ball():
	init_cartridge += 1

func _on_start_timer_timeout():
	wait = true
