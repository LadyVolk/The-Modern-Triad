tool

extends KinematicBody2D

onready var timer = $Timer

signal depression_shoot
signal new_target_position
signal create_delusion

var target_destination
var speed = 300
var invincible = false
var boss_state = 1
var player = null
var is_delusion = false

export var health = 200

func _ready():
	AudioManager.play_sfx("depression_music", 0)


func _on_Timer_timeout():
	if not player:
		return
	if boss_state == 1:
		randomize()
		var angle_rad =  rand_range(0, 2*PI)
		var number = 20
		for _i in range(0, number):
			emit_signal("depression_shoot", global_position, 
						Vector2(cos(angle_rad), sin(angle_rad)))
			angle_rad += 2*PI/number
	elif boss_state == 2:
		var direction = player.global_position - global_position
		var number_shoots = 5
		var shoot_spread = PI/4
		var angle_each_ball = shoot_spread/ (number_shoots - 1)
		var initial_angle = direction.angle() - shoot_spread/2
		for i in number_shoots:
			emit_signal("depression_shoot", global_position, 
							Vector2(cos(initial_angle), sin(initial_angle)))
			initial_angle += angle_each_ball
	
	elif boss_state == 3:
		var direction = player.global_position - global_position
		var number_shoots = 5
		var shoot_spread = PI/4
		var angle_each_ball = shoot_spread/ (number_shoots - 1)
		var initial_angle = direction.angle() - shoot_spread/2
		for i in number_shoots:
			emit_signal("depression_shoot", global_position, 
							Vector2(cos(initial_angle), sin(initial_angle)))
			initial_angle += angle_each_ball	
	
	
func _physics_process(delta):
	if target_destination and not invincible:
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
	if is_delusion:
		return
	boss_state = new_stage
	invincible = true
	$AnimationPlayer.play("change_state")
	$Tween.interpolate_property(self, "scale", scale, scale*0.7, 1, 
								Tween.TRANS_LINEAR, Tween.EASE_OUT_IN)
	$Tween.start()
	$Timer.stop()
	yield($AnimationPlayer, "animation_finished")
	invincible = false
	if new_stage == 2:
		$Timer.start()
		$Timer.wait_time = 3	
	if new_stage == 3:
		$Timer.start()
		$Timer.wait_time = 3
	

func _on_TimerDelusion_timeout():
	if is_delusion:
		return
	if boss_state == 3:
		emit_signal("create_delusion", position)
		
		
		
		
		
		
		
