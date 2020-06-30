extends KinematicBody2D

signal shoot
signal update_health
signal set_HUD

onready var image = $Image
onready var animation = $AnimationPlayer

export var speed: int
export var dash_strength = 40000
export var max_speed = 400
export var min_speed = 100
export var speed_boost = 300
export var speed_slowdown = 30
export var max_health = 100
export var max_still_time = 0.2 
export var still_damage = 30
export var movement_heal = 8

var health
var dash_movement = Vector2()
var movement = Vector2()
var knockback_movement = Vector2()
var mode = "depression"
var still_time = 0
var attacking = false
var stunned = false
var player_hit_stun = 0.1
var debug = false

const melee_damage = 5
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
		apply_friction(speed*2 * delta)
		
		still_time += delta
		if still_time >= max_still_time:
			take_damage(still_damage * delta)
	
	if (mov_vector != Vector2.ZERO or dash_movement.length() > 0) \
		and not stunned:
		still_time = 0
		
		heal(movement_heal*delta)
	
	movement = move_and_slide(movement + dash_movement*delta + 
							  knockback_movement*delta)

	
	update_player_sprite()
	
	#slowdown by depression
	max_speed = max(min_speed, max_speed - speed_slowdown * delta)
	

func _input(event):
	if event.is_action_pressed("player_dash"):
		dash()
	elif event.is_action_pressed("shoot"):
		emit_signal("shoot", position, get_player_direction())
	elif event.is_action_pressed("melee_attack"):
		melee_attack()
		
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
							Vector2(), dash_time, Tween.TRANS_QUAD, Tween.EASE_OUT_IN)
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
	if attacking:
		return
		
	var angle = rad2deg(get_player_direction().angle())	
	
	if angle < 0:
		angle += 360
	
	var direction = get_direction_name(angle)
	
	if movement.length() <= 0.1:
		animation.play("idle_"+direction)
	else: 
		animation.play("running_"+direction)
	
	
	
func take_damage(damage):
	
	if debug:
		return
	
	health -= damage
	
	emit_signal("update_health", health)
	
	if health <= 0:
		die()
	
	
func die():
	queue_free()
	
func heal(heal):
	health = min(max_health, health+heal)
	
	emit_signal("update_health", health)	
	 
	
func stun(stun_time, direction, force):
	if stunned:
		return
	
	stunned = true
	
	if direction:
		knockback(direction, force)
	
	yield(get_tree().create_timer(stun_time), "timeout")
	
	stunned = false
	
	
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
		return "top"
	
	#right
	elif angle >= 315 or angle < 45:
		return "right"
	
	#bottom 
	elif angle >= 45 and angle < 135:
		return "bottom"
	
	#left
	elif angle >= 135 and angle < 225:
		return "left"
	

func _on_Damage_body_shape_entered(_body_id, body, _body_shape, _area_shape):
	if not $Damage.visible:
		return
	if(body.is_in_group("boss")):
		body.take_damage(melee_damage)
		$AnimationPlayer.stop(false)
		yield(get_tree().create_timer(player_hit_stun), "timeout")
		$AnimationPlayer.play()


func knockback(direction, force):
	$Tween.interpolate_property(self, "knockback_movement", 
								direction.normalized() * force, Vector2(),
								0.4,Tween.TRANS_QUAD, Tween.EASE_OUT)
	$Tween.start()							
	

