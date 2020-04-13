extends Area2D

signal destroyed
signal hitted(display)
signal pts(qt)
signal change_anim

var health_idx = 80
var min_health_idx = 15
onready var init_health : float = randi() % health_idx + 15
onready var health : float = init_health

func _ready():
	pass

func hit(damage , node):
#	$"../sprite".play("hit")
	emit_signal("change_anim")
	health -= damage
	emit_signal("pts" , damage)
	var show_lv : float = health / init_health
	emit_signal("hitted" , show_lv)
	if health <= 0:
		emit_signal("destroyed")

func _process(delta):
	$"../label_node/label".text = str(health)
