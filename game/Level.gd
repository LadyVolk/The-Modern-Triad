extends Node2D

const PROJECTILE = preload("res://Projectile.tscn")

onready var player = $Player

func _ready():
	player.connect("shoot", self, "player_shoot")



func player_shoot(pos, direction):
	var new_projectile = PROJECTILE.instance()
	$Projectiles.add_child(new_projectile)
	new_projectile.position = pos
	new_projectile.direction = direction
