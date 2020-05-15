extends Node2D

var direction
export var speed = 1000

func _ready():
	direction = Vector2()

func _process(delta):
	position += speed * delta * direction
