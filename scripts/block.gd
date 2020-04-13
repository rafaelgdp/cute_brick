extends StaticBody2D

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

signal bonus_pts(bonus)

func _ready():
	var sprite = $sprite.get_material().duplicate(true)
	$sprite.set_material(sprite)
	
	var skin = [
	preload("res://sprites/1st_level_block.png"), #0
	preload("res://sprites/2nd_level_block.png"), #1
	preload("res://sprites/3rd_level_block.png"), #2
	preload("res://sprites/4th_level_block.png"), #3
	preload("res://sprites/5th_level_block.png"), #4
	preload("res://sprites/6th_level_block.png"), #5
	preload("res://sprites/7th_level_block.png"), #6
	preload("res://sprites/8th_level_block.png"), #7
	preload("res://sprites/9th_level_block.png"), #8
	preload("res://sprites/10th_level_block.png")  #9
	]

	randomize()
	var skin_pos = randi()%9
#	$sprite.set_texture(skin[skin_pos])
	$sprite.play("idle")
	$area.connect("hitted" , self , "on_area_hitted")
	$area.connect("destroyed" , self , "on_area_destroyed")
	$area.connect("change_anim" , self , "on_change_anim")

func on_change_anim():
	$sprite.play("hurt")
	shake_block()
	$sprite.connect("animation_finished" , self , "on_anim_finished")

func shake_block():
	$sprite.position = Vector2(3,0)
	$sprite.position = Vector2(0,3)
	$sprite.position = Vector2(-3,0)
	$sprite.position = Vector2(0,-3)

func on_anim_finished():
	$sprite.play("idle")

func on_area_hitted(display):
	$hit.play()
	if display < 0.1:
		display = 0.1
	$sprite.material.set_shader_param("show" , display)
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
