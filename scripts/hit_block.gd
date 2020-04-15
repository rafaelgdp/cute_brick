extends Area2D

signal destroyed
signal hitted
signal pts(qt)
signal change_anim(skin_pos)
signal change_color

var health_idx = 20
var min_health_idx = 15
var color = 0

onready var init_health : float = randi() % health_idx + 15
onready var health : float = init_health

func _ready():
	pass

func hit(damage , node):
	if health < init_health - (init_health * 0.9):
		color = 9
	elif health < init_health -(init_health * 0.8):
		color = 8
	elif health < init_health -(init_health * 0.7):
		color = 7
	elif health < init_health -(init_health * 0.6):
		color = 6
	elif health < init_health -(init_health * 0.5):
		color = 5
	elif health < init_health -(init_health * 0.4):
		color = 4
	elif health < init_health -(init_health * 0.3):
		color = 3
	elif health < init_health -(init_health * 0.2):
		color = 2
	elif health < init_health -(init_health * 0.1):
		color = 1
	else:
		color = 0
	emit_signal("change_anim" , color)
	health -= damage
	emit_signal("pts" , damage)
	emit_signal("hitted")
	if health <= 0:
		emit_signal("destroyed")

func _process(delta):
	$"../label_node/label".text = str(health)
