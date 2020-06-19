extends Node2D

var region

func _ready():
	pass 

func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		activate(body)


func activate(player):
	player.stun(2, false, false)
	queue_free()
	
