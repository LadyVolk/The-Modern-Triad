extends KinematicBody2D

onready var timer = $Timer

signal new_target_position

var target_destination
var speed = 300
var invincible = false
var boss_state = 1
var player = null

export var health = 200

func _ready():
	pass
	
	
func _physics_process(delta):
	if target_destination and not invincible and not Global.freeze:
		var how_much = delta*speed
		
		var move_x = how_much_to_move(target_destination.x, position.x, how_much)
		var move_y = how_much_to_move(target_destination.y, position.y, how_much)
		
		var move = Vector2(move_x, move_y)	
		
# warning-ignore:return_value_discarded
		move_and_collide(move)
		
		if abs(target_destination.x - position.x) < 5:
			position.x = target_destination.x
		if abs(target_destination.y - position.y) < 5:
			position.y = target_destination.y
		
		
		if move.length() <= 1:
			$TimerPosition.start()
			target_destination = null
	
	
func how_much_to_move(target_position, origin_position, how_much):
	var difference = (target_position - origin_position)

	if abs(difference) >= how_much:
		return -how_much if difference < 0 else how_much
	else:
		return -difference
	
func _on_TimerPosition_timeout():
	emit_signal("new_target_position", self)
	
func take_damage(damage):
	if invincible:
		return
	
	AudioManager.play_sfx("damage_boss", 0.2)
	
	health -= damage
	
	if health <= 200 and health > 140:
		$AnimationPlayer.stop()
		$AnimationPlayer.play("stun")
	
	elif health <= 140 and health > 70:
		$AnimationPlayer.stop()
		$AnimationPlayer.play("stun")
		if boss_state == 1:
			change_state(2)
	elif health <= 70 and health > 0:
		$AnimationPlayer.stop()
		$AnimationPlayer.play("stun")
		if boss_state == 2:
			change_state(3)
	else:
		die()


func die():
	queue_free()
	
func play_idle():
	$AnimationPlayer.play("idle")
	
func change_state(new_stage):
	pass
	
		
		
		
		
