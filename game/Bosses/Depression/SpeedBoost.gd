extends Node2D

var region

func _ready():
	pass 


func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		activate(body)


func activate(player):
	AudioManager.play_sfx("speed_boost", 0.2)
	player.max_speed += player.speed_boost
	queue_free()
	
