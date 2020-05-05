extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


func _ready():
	$Label.text = "life is great"



func _process(delta):
	if Input.is_action_pressed("player_up"):
		position.y -= 10
	if Input.is_action_pressed("player_down"):
		position.y += 10
	if Input.is_action_pressed("player_right"):
		position.x += 10
	if Input.is_action_pressed("player_left"):
		position.x -= 10
