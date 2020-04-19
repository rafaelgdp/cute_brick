extends Node2D

func _ready():
	SIGN.connect("hide_health" , self , "on_hide_health")

func on_hide_health():
	$label.visible = false
