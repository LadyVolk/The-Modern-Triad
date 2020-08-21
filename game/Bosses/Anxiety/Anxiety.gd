extends KinematicBody2D


signal new_target_position
signal anxiety_attack
signal change_player_speed

var target_destination
var speed = 1000
var invincible = false
var boss_state = 1
var player = null
var boss_stop = false
var attack_cooldown_on = false

export var health = 200


func _ready():
	pass
	
	
func _physics_process(delta):
	if target_destination and not invincible and not Global.freeze and not boss_stop:
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
	
	$AnimationPlayer.play("Pulse")
	
	if health <= 100:
		emit_signal("change_player_speed")
	
	elif health <= 0:
		die()


func die():
	queue_free()
	
func play_idle():
	$AnimationPlayer.play("idle")
	
func change_state(new_stage):
	pass	
	

func stop_boss():
	boss_stop = true
	$MeditationTimer.start()
	yield($MeditationTimer, "timeout")
	boss_stop = false
	

func _on_Area2D_body_entered(body):
	if body.is_in_group("player") and not attack_cooldown_on:
		$TimerAttack.start()
		attack_cooldown_on = true
		emit_signal("anxiety_attack", 25)


func _on_TimerAttack_timeout():
	attack_cooldown_on = false


func increase_speed():
	speed = 2000

func decrease_speed():
	speed = 1000
