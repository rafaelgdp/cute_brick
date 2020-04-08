extends Area2D

signal destroyed
signal hitted(display)
signal pts(qt)

onready var init_health : float = randi() % 80 + 15
onready var health : float = init_health

func _ready():
	pass

func hit(damage , node):
	health -= damage
	emit_signal("pts" , damage)
	var show_lv : float = health / init_health
	emit_signal("hitted" , show_lv)
	if health <= 0:
		emit_signal("destroyed")

func _process(delta):
	$"../label_node/label".text = str(health)
