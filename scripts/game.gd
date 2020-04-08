extends Node2D

onready var pre_brick = preload("res://scenes/block.tscn")
var stop = false
var total_pts = 0

var brick_x_idx = [
16,  #0
48,  #1
80,  #2
112, #3
144, #4
176, #5
208, #6
240, #7
272, #8
304, #9
336  #10
]
var brick_y_idx = [
48,  #0
80,  #1
112, #2
144, #3
176, #4
208, #5
240, #6
272, #7
304, #8
336  #9
]

signal stop_shoot(state)
signal shade_all(shade)

func _ready():
	add_bricks(brick_y_idx.size())

	$shoot.connect("empty" , $bottom/area , "on_empty")
	$bottom/area.connect("recharge" , $shoot , "on_recharge")
	$bottom/area.connect("game_over" , self , "on_game_over")
	$bottom/area.connect("brick_down" , self , "on_brick_down")
	self.connect("stop_shoot" , $shoot , "on_stop_shoot")

func _draw():
	draw_rect(Rect2(Vector2(0,0),Vector2(352,640)),Color(0,0,0,1),true)

func on_brick_down():
	if stop == false:
		var br = get_tree().get_nodes_in_group("bricks")
		for i in range(0 , br.size()):
			br[i].position.y += 32
		
		add_bricks(1)

func _process(delta):
	$pts_label.text = str("Points: " , total_pts)

func on_pts(pts):
	total_pts += pts

func add_bricks(y):
	var brick_y_size = y
	var brick_x_size = brick_x_idx.size()
	for l in range(0,brick_y_size):
		for i in range(0,brick_x_size):
			randomize()
			var add_brick = randi()%4
			if add_brick == 1 or add_brick == 2:
				var brick = pre_brick.instance()
				brick.global_position = Vector2(brick_x_idx[i],brick_y_idx[l])
				add_child(brick)
				brick.add_to_group("bricks")
				brick.get_node("area").connect("pts" , self , "on_pts")

func on_game_over():
	stop = true
	$shoot/interval.stop()
	$shoot.visible = false
	$shoot_sprite.visible = false
	$label_node/game_over_label.visible = true
	$label_node/game_over_label/go_pts_label.text = str("Total Points\n" , total_pts)
	for i in get_tree().get_nodes_in_group("bricks"):
		i.get_node("sprite").material.set_shader_param("show" , 0.1)
		i.get_node("label_node").visible = false
	emit_signal("stop_shoot" , false)
