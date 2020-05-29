extends KinematicBody2D

var direction
export var speed = 1000

signal stun_player

func _ready():
	direction = Vector2()

func _physics_process(delta):

	var collision = move_and_collide(speed * delta * direction)
		
	if collision:
		if collision.collider.is_in_group("walls"):
			queue_free()
		elif collision.collider.is_in_group("player"):
			emit_signal("stun_player")
			queue_free()

