extends Node2D

signal entered_mirror

func _ready():
	pass 


func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		emit_signal("entered_mirror")

