extends Area2D

signal destroyed
signal hitted(display)

onready var init_health : float = randi()%100+32
onready var health : float = init_health

func _ready():
	pass

func hit(damage , node):
	health -= damage
	var show_lv : float = health / init_health
	print(show_lv)
	emit_signal("hitted" , show_lv)
	if health <= 0:
		emit_signal("destroyed")

func _process(delta):
	$"../label_node/label".text = str(health)
