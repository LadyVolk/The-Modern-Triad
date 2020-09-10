extends KinematicBody2D

signal died

onready var image = $Image
onready var animation = $AnimationPlayer

export var speed: int
export var max_speed = 400
export var min_speed = 100
export var max_health = 100

var player
var health
var dash_movement = Vector2()
var knockback_movement = Vector2()
var attacking = false
var debug = false
var died = false
var sprite_direction = "bottom"
var disable = false
var send_stop_signal = false
var mode

const melee_damage = 5
const dash_time = 0.2
const player_sprites = {"top": preload("res://assets/images/player/player_top.png"),
						"bottom": preload("res://assets/images/player/player_botton.png"),
						"left": preload("res://assets/images/player/player_left.png"),
						"right": preload("res://assets/images/player/player_right.png"),
						"running": preload("res://assets/images/player/running.png")
						}

func _ready():
	health = max_health

		
func _process(delta):		
# warning-ignore:return_value_discarded
	move_and_slide(-(player.movement + dash_movement*delta + 
							  knockback_movement*delta))
	
	update_player_sprite()
	

func _input(event):
	
	if event.is_action_pressed("melee_attack"):
		melee_attack()
				
				
func get_player_direction():
	var mouse_pos = get_viewport().get_mouse_position()
	var center_player = get_global_transform_with_canvas().origin
	
	return  (mouse_pos - center_player).normalized()
	

func update_player_sprite():
	if attacking:
		return
		
	#var angle = rad2deg(get_player_direction().angle())	
	
	if player.movement.length() <= 0.1:
		animation.play("idle_"+sprite_direction)
	else:
		var angle = rad2deg(player.movement.angle())
	
		if angle < 0:
			angle += 360
		
		sprite_direction = get_direction_name(angle)
		animation.play("running_"+sprite_direction)
		
	
	
func take_damage(damage):
	
	if debug:
		return
	
	health -= damage
	
	if health <= 0:
		die()
	
	
func die():
	if died:
		return	
	died = true
	randomize()
	var number = randi()%4+1
	AudioManager.play_sfx("player_death_"+str(number), 0.2)
	
	emit_signal("died")
	queue_free()
	
	
func melee_attack():
	if attacking:
		return
	attacking = true

	var angle = rad2deg(get_player_direction().angle())	
	
	if angle < 0:
		angle += 360
	
	animation.play("attack_"+get_direction_name(angle))
	
	AudioManager.play_sfx("melee_player", 0.1)
	
	yield(animation, "animation_finished")
	
	animation.play("idle_"+get_direction_name(angle))
	
	attacking = false
	
	
func get_direction_name(angle):
	#top
	if angle >= 225 and angle < 315:
		return "bottom"
	
	#right
	elif angle >= 315 or angle < 45:
		return "left"
	
	#bottom 
	elif angle >= 45 and angle < 135:
		return "top"
	
	#left
	elif angle >= 135 and angle < 225:
		return "right"
	
