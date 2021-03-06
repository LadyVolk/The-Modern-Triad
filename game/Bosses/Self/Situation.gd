extends KinematicBody2D

var direction

const force = 15000

export var speed = 600

signal situation_damage

func _ready():
	direction = Vector2()

func _physics_process(delta):

	var collision = move_and_collide(speed * delta * direction)
		
	if collision:
		if collision.collider.is_in_group("walls"):
			queue_free()
		elif collision.collider.is_in_group("player"):
			emit_signal("situation_damage", "player")
			queue_free()
		elif collision.collider.is_in_group("self"):
			emit_signal("situation_damage", "self")
			queue_free()
