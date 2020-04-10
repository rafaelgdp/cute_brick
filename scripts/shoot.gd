extends KinematicBody2D


var ball = preload("res://scenes/ball.tscn")
var velocity = Vector2()
export (int) var init_cartridge = 5
var cartridge = init_cartridge
var initial_pos = Vector2()
var wait = true

func _ready():
	add_to_group("muzzle")
	SIGN.connect("recharge" , self , "on_recharge")
	
		
func get_input():
	velocity = Vector2()
	var m_input = Input.is_action_just_pressed("ui_shoot")
	if m_input:
		if wait:
			initial_pos = get_global_mouse_position() - $muzzle.global_position
			wait = false
			shoot()
		else:
			pass

func shoot():
	if cartridge > 0:
		var b = ball.instance()
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

func _physics_process(delta):
	if wait:
		get_input()
	else:
		pass
	var str_cart = str(cartridge)
	SIGN.emit_signal("update_cartridge" , str_cart)
#	$"../shoot_sprite/shoot_label".text = str(cartridge)

func _on_interval_timeout():
	shoot()

func on_recharge(waiting):
	cartridge = init_cartridge
	wait = waiting

func on_stop_shoot(state):
	wait = state
