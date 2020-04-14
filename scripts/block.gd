extends StaticBody2D

onready var skin = [
	"white",		#0
	"pink",			#1
	"green",		#2
	"cyan",			#3
	"blue",			#4
	"purple",		#5
	"heavy_blue",	#6
	"yellow",		#7
	"orange",		#8
	"red"			#9
]

onready var pos_y_idx = [
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

var color_idx = 0

signal bonus_pts(bonus)

func _ready():
	var sprite = $sprite.get_material().duplicate(true)
	$sprite.set_material(sprite)

	$sprite.play("idle-" + skin[color_idx])
	$area.connect("hitted" , self , "on_area_hitted")
	$area.connect("destroyed" , self , "on_area_destroyed")
	$area.connect("change_anim" , self , "on_change_anim")

func on_change_anim(color):
	print("skin: " , skin[color])
	$sprite.play("hurt-" + skin[color])
	color_idx = color
	$block_hit.play("hit")
	if is_connected("animation_finished" , self , "on_animation_finished"):
		$sprite.disconnect("animation_finished" , self , "on_anim_finished")
		$sprite.connect("animation_finished" , self , "on_anim_finished")
	else:
		$sprite.connect("animation_finished" , self , "on_anim_finished")

func on_anim_finished():
	print("skin2: " , skin[color_idx])
	$sprite.play("idle-" + skin[color_idx])
	$sprite.disconnect("animation_finished" , self , "on_anim_finished")

func on_area_hitted():
	$hit.play()
#	if display < 0.1:
#		display = 0.1
#	$sprite.material.set_shader_param("show" , display)
	yield($hit , "finished")

func on_area_destroyed():
	$destroyed.play()
	$area.queue_free()
	$sprite.queue_free()
	$collision.queue_free()
	$label_node.queue_free()
	yield($destroyed , "finished")
	emit_signal("bonus_pts" , 10)
	self.queue_free()

func _on_area_area_entered(area):
	if area.has_method("touch_bottom"):
		area.touch_bottom(self)
