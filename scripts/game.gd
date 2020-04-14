extends Node2D

# onready vars
# preload the blocks, the shooter and game over menu
onready var pre_brick = preload("res://scenes/block.tscn")
onready var pre_shoot = preload("res://scenes/shoot.tscn")
onready var pre_game_over = preload("res://scenes/game_over.tscn")

var stop = false
var total_pts = 0
var pts_counter = 0
var shoot_node = null
var go_node = null
var health_bonus = 0
var min_health_bonus = 0
var hide_aim = false

#
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

const LINE_LENGTH = 15

func _ready():
# Call add_bricks to add the initial blocks
	add_bricks(brick_y_idx.size())
	add_shooter()

# Connections to signals
	SIGN.connect("game_over" , self , "on_game_over")
	SIGN.connect("brick_down" , self , "on_brick_down")
	SIGN.connect("new_game" , self , "on_new_game")
	SIGN.connect("update_cartridge" , self , "on_update_cartridge")
	SIGN.connect("aim" , self , "aim")

func _draw():
	draw_rect(Rect2(Vector2(0,0),Vector2(352,640)),Color(0,0,0,1),true)
	var start = $shoot_sprite.global_position
	var dir = start.direction_to(get_global_mouse_position())
	var end = start + (dir*LINE_LENGTH)
	if hide_aim == false and stop == false:
		for i in range(1 , 12):
			var c = i
			if (c % 2) != 0:
				draw_line(start, end , Color(0,1,0,1), 2)
			else:
				draw_line(start, end , Color(0,0,0,0))
			var next_start = end
			start = next_start
			end = start + (dir*LINE_LENGTH)
	else:
		draw_line(start, end , Color(0,0,0,1), 1)

func _process(delta):
	$pts_label.text = str("Points: " , total_pts)
	update()

# "Add" functions
# Add the shooter and the blocks
# Store the nodes in the groups "muzzle" and "bricks" respectively
func add_shooter():
	var s = pre_shoot.instance()
	s.add_to_group("muzzle")
	s.global_position = Vector2(180 , 630)
	call_deferred("add_child" , s)

func aim(state):
	hide_aim = state

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
				brick.get_node("area").health_idx += health_bonus
				brick.get_node("area").min_health_idx += min_health_bonus
				call_deferred("add_child" , brick)
				brick.add_to_group("bricks")
				brick.get_node("area").connect("pts" , self , "on_pts")
				brick.connect("bonus_pts" , self , "on_bonus_pts")

# Function on_brick_down()
# Controls how the blocks go down
func on_brick_down():
	if stop == false:
		var br = get_tree().get_nodes_in_group("bricks")
		for i in range(0 , br.size()):
			br[i].position.y += 32
		
		add_bricks(1)

# Points functions
# Updates the points and points counter
# Add healt_bonus to update the difficulty of the game,
# making blocks healthier
func on_pts(pts):
	total_pts += pts
	pts_counter += pts
	if pts_counter == 2000:
		health_bonus += 5
		min_health_bonus += 5
		pts_counter = 0

# Increases total_pts when a block is destroyed
func on_bonus_pts(bonus):
	total_pts += bonus

func on_update_cartridge(cartridge):
	$shoot_sprite/shoot_label.text = cartridge

# Function on_game_over()
# Display game over screen, hide block health
# and queue_free() the shooter when the game is over
func on_game_over():
	stop = true

	# Hide blocks health points
	var b_roll = get_tree().get_nodes_in_group("bricks")
	for i in b_roll:
		i.get_node("label_node").visible = false

	# Queue free the shooter
	# Hides the shooter sprite
	var m = get_tree().get_nodes_in_group("muzzle")
	m[0].queue_free()
	$shoot_sprite.visible = false
	
	# Add the game over display into the scene
	if go_node == null:
		add_display()
	else:
		pass

func add_display():
	go_node = pre_game_over.instance()
	call_deferred("add_child" , go_node)
	go_node.get_node("game_over_label/go_pts_label").text = str("Total Points\n" , total_pts)

# Function
func on_new_game():
	stop = false
	go_node = null
	# Resets the points e points counter
	total_pts = 0
	pts_counter = 0
	health_bonus = 0
	min_health_bonus = 0
	
	# Clear the blocks
	var b = get_tree().get_nodes_in_group("bricks")
	for i in b:
		i.queue_free()
		i.remove_from_group("bricks")
	
	# Add blocks again
	add_bricks(brick_y_idx.size())
	
	# Add shooter again
	var s = pre_shoot.instance()
	s.add_to_group("muzzle")
	s.global_position = Vector2(180 , 630)
	get_parent().call_deferred("add_child" , s)
	$shoot_sprite.visible = true
	
	# Queue free game over node from scene
	SIGN.emit_signal("clear_screen")
	$shoot_sprite.global_position = Vector2(180 , 630)
