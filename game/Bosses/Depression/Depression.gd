extends Node2D

onready var timer = $Timer

signal depression_shoot

func _ready():
	pass 


func _on_Timer_timeout():
	emit_signal("depression_shoot", global_position)
