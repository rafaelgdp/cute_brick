extends Node2D

onready var pre_brick = preload("res://scenes/block.tscn")

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

func _ready():
	var brick_y_size = brick_y_idx.size()
	var brick_x_size = brick_x_idx.size()
	for l in range(0,brick_y_size):
		for i in range(0,brick_x_size):
			randomize()
			var add_brick = randi()%2
			if add_brick == 1:
				var brick = pre_brick.instance()
				brick.global_position = Vector2(brick_x_idx[i],brick_y_idx[l])
				add_child(brick)

func _draw():
	draw_rect(Rect2(Vector2(0,0),Vector2(352,640)),Color(0,0,0,1),true)
