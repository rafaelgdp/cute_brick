extends KinematicBody2D


var ball = preload("res://scenes/ball.tscn")
var velocity = Vector2()
export (int) var init_cartridge = 50
var cartridge = init_cartridge
var initial_pos = Vector2()
var wait = true
var b = null
var g_max:float = 0

func _ready():
	add_to_group("muzzle")
	SIGN.connect("recharge" , self , "on_recharge")

func get_input():
	velocity = Vector2()
	var m_input = Input.is_action_just_released("ui_shoot")
#	var m_input = Input.is_action_just_pressed("ui_shoot")
	if m_input:
		if wait:
			initial_pos = get_global_mouse_position() - $muzzle.global_position
			wait = false
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
		print()
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

#func change_speed():
#	var mult:float = 0
#	var g:float = get_tree().get_nodes_in_group("balls").size()
#	if g_max != null && g_max != 0 && g != 0:
#		print("g_max: " , g_max , "/ g: " , g)
#		var div:float = g_max / g
#		mult = div
#		print("mult: " , mult)
#	print(is_instance_valid(b))
#	if is_instance_valid(b) && b != null:
#		b.speed = 800 * mult
##		print("b.speed: " , b.speed)
#	pass
