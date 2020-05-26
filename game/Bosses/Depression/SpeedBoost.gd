extends Node2D


func _ready():
	pass 



func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		activate(body)


func activate(player):
	player.max_speed += player.speed_boost
	queue_free()
	
