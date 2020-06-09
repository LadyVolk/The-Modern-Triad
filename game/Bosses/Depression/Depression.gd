extends KinematicBody2D

onready var timer = $Timer

signal depression_shoot
signal new_target_position

var target_destination
var speed = 300

func _ready():
	pass


func _on_Timer_timeout():
	randomize()
	var angle_rad =  rand_range(0, 2*PI)
	var number = 8
	for _i in range(0, number):
		emit_signal("depression_shoot", global_position, 
					Vector2(cos(angle_rad), sin(angle_rad)))
		angle_rad += 2*PI/number

func _physics_process(delta):
	if target_destination:
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
	emit_signal("new_target_position")
