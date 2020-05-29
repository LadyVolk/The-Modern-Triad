extends Node2D

onready var timer = $Timer

signal depression_shoot

func _ready():
	pass


func _on_Timer_timeout():
	randomize()
	var angle_rad =  rand_range(0, 2*PI)
	var number = 8
	for i in range(0, number):
		emit_signal("depression_shoot", global_position, 
					Vector2(cos(angle_rad), sin(angle_rad)))
		angle_rad += 2*PI/number

func _physics_process(delta):
	
