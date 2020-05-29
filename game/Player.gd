extends KinematicBody2D

signal shoot
signal update_health
signal set_HUD

onready var image = $Image
onready var animation = $AnimationPlayer

export var speed: int
export var dash_strength = 18000
export var max_speed = 400
export var min_speed = 100
export var speed_boost = 300
export var speed_slowdown = 40
export var max_health = 100
export var max_still_time = 0.2 
export var still_damage = 30
export var movement_heal = 5

var health
var dash_movement = Vector2()
var movement = Vector2()
var mode = "depression"
var still_time = 0
var stunned = false

const dash_time = 0.2
const player_sprites = {"top": preload("res://assets/images/player/player_top.png"),
						"bottom": preload("res://assets/images/player/player_botton.png"),
						"left": preload("res://assets/images/player/player_left.png"),
						"right": preload("res://assets/images/player/player_right.png"),
						"running": preload("res://assets/images/player/running.png")
						}

func _ready():
	$Label.text = "life is great"
	health = max_health
	emit_signal("set_HUD", max_health)

func _process(delta):
	
	var mov_vector = Vector2(0, 0)
	if Input.is_action_pressed("player_up"):
		mov_vector.y -= 1
	if Input.is_action_pressed("player_down"):
		mov_vector.y += 1
	if Input.is_action_pressed("player_right"):
		mov_vector.x += 1
	if Input.is_action_pressed("player_left"):
		mov_vector.x -= 1 
	
	mov_vector = mov_vector.normalized()

	if mov_vector != Vector2.ZERO and not stunned:
		apply_movement(mov_vector * speed * delta)
	else:
		apply_friction(speed * delta)
		
		still_time += delta
		if still_time >= max_still_time:
			take_damage(still_damage * delta)
	
	if (mov_vector != Vector2.ZERO or dash_movement.length() > 0) \
		and not stunned:
		still_time = 0
		
		heal(movement_heal*delta)
	
	movement = move_and_slide(movement + dash_movement*delta)
# warning-ignore:return_value_discarded
	move_and_slide(dash_movement*delta)
	
	update_player_sprite()
	
	#slowdown by depression
	max_speed = max(min_speed, max_speed - speed_slowdown * delta)

func _input(event):
	if event.is_action_pressed("player_dash"):
		dash()
	if event.is_action_pressed("shoot"):
		emit_signal("shoot", position, get_player_direction())

func get_player_direction():
	
	var mouse_pos = get_viewport().get_mouse_position()
	var center_player = global_position
	
	return  (mouse_pos - center_player).normalized()
	
	
func dash():
	if not $DashCooldown.is_stopped() or stunned:
		return
		
	$DashCooldown.start()
	
	movement = Vector2()
	var direction = get_player_direction()
	$Tween.interpolate_property(self, "dash_movement", direction * dash_strength,
							Vector2(), dash_time, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()

func apply_movement(acceleration):
	movement += acceleration
	movement = movement.clamped(max_speed)
	

func apply_friction(acceleration):
	if movement.length() > acceleration:
		movement -= movement.normalized() * acceleration
	else:
		movement = Vector2()


func update_player_sprite():
	var angle = rad2deg(get_player_direction().angle())+90
	
	if angle < 0:
		angle += 360
	
	#top
	if angle >= 315 or angle < 45:
		if movement.length() <= 0.1:
			animation.play("idle_top")
		else: 
			animation.play("running_top")
	
	#right
	elif angle >= 45 and angle < 135:
		if movement.length() <= 0.1:
			animation.play("idle_right")
		else: 
			animation.play("running_right")
	
	#bottom 
	elif angle >= 135 and angle < 225:
		if movement.length() <= 0.1:
			animation.play("idle_bottom")
		else: 
			animation.play("running_bottom")
	
	#left
	elif angle >= 225 and angle < 315:
		if movement.length() <= 0.1:
			animation.play("idle_left")
		else: 
			animation.play("running_left")
	
	
func take_damage(damage):
	health -= damage
	
	emit_signal("update_health", health)
	
	if health <= 0:
		die()
	
	
func die():
	queue_free()
	
func heal(heal):
	health = min(max_health, health+heal)
	
	emit_signal("update_health", health)	
	 
	
func stun(stun_time):
	
	if stunned:
		return
	
	stunned = true
	
	yield(get_tree().create_timer(stun_time), "timeout")
	
	stunned = false
	
	
