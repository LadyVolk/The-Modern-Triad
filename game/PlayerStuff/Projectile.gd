extends KinematicBody2D

class_name Projectile

var direction
export var speed = 30000

func _ready():
	direction = Vector2()

func _physics_process(delta):

	var collision = move_and_collide(speed * delta * direction)

	if collision and collision.collider.is_in_group("walls"):
		queue_free()
