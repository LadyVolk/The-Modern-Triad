extends KinematicBody2D

class_name Projectile

var direction
export var speed = 1000

signal shoot_at_boss

func _ready():
	direction = Vector2()


func _physics_process(delta):

	var collision = move_and_collide(speed * delta * direction)

	if collision and collision.collider.is_in_group("walls"):
		queue_free()
	elif collision and collision.collider.is_in_group("boss"):
		emit_signal("shoot_at_boss")
		queue_free()

