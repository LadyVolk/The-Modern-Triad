extends KinematicBody2D

signal shoot
signal update_health
signal set_HUD
signal died
signal stop_boss

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
export var mode = "anxiety"

var health
var dash_movement = Vector2()
var movement = Vector2()
var knockback_movement = Vector2()
var still_time = 0
var attacking = false
var stunned = false
var player_hit_stun = 0.1
var debug = false
var died = false
var sprite_direction = "bottom"
var disable = false
var send_stop_signal = false

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
	emit_signal("set_HUD", max_health)

	if mode == "depression" or mode == "anxiety":
		$Camera.queue_free()
	elif mode == "transition":
		$Camera.current = true
		$Camera.zoom = Vector2(0.5, 0.5)
		
		
func _process(delta):
	if disable or Global.freeze:
		return
	if send_stop_signal:
		emit_signal("stop_boss")
		send_stop_signal = false
	
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
		if mode == "depression":
			still_time += delta
			if still_time >= max_still_time:
				take_damage(still_damage * delta)
	
	if mode == "depression" and (mov_vector != Vector2.ZERO or dash_movement.length() > 0) \
		and not stunned:
		still_time = 0
		
		heal(movement_heal*delta)
	
	movement = move_and_slide(movement + dash_movement*delta + 
							  knockback_movement*delta)

	
	update_player_sprite()
	
	if mode == "depression":
		#slowdown by depression
		max_speed = max(min_speed, max_speed - speed_slowdown * delta)
	

func _input(event):
	if mode == "depression":
		if event.is_action_pressed("player_dash"):
			dash()
		elif event.is_action_pressed("melee_attack"):
			melee_attack()
	if mode == "anxiety":
		if event.is_action_pressed("player_dash"):
			dash()
		elif event.is_action_pressed("shoot"):
			emit_signal("shoot", position, get_player_direction())
				
				
func get_player_direction():
	var mouse_pos = get_viewport().get_mouse_position()
	var center_player = get_global_transform_with_canvas().origin
	
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
		
	#var angle = rad2deg(get_player_direction().angle())	
	
	if movement.length() <= 0.1:
		animation.play("idle_"+sprite_direction)
	else:
		var angle = rad2deg(movement.angle())
	
		if angle < 0:
			angle += 360
		
		sprite_direction = get_direction_name(angle)
		animation.play("running_"+sprite_direction)
		
	
	
func take_damage(damage):
	
	if debug:
		return
	
	health -= damage
	
	emit_signal("update_health", health)
	
	if health <= 0:
		die()
	
	
func die():
	if died:
		return	
	died = true
	randomize()
	var number = randi()%4+1
	AudioManager.play_sfx("player_death_"+str(number), 0.2)
	
	if not stunned:
		emit_signal("died")
		queue_free()
	else:
		visible = false
		set_collision_layer(0)
		set_collision_mask(0)
		
		
func heal(heal):
	health = min(max_health, health+heal)
	
	emit_signal("update_health", health)	
	 
	
func stun(stun_time, direction, force):
	if stunned:
		return
	
	AudioManager.play_sfx("stun_sound", 0.2)
	
	stunned = true
	
	if direction:
		knockback(direction, force)
	
	yield(get_tree().create_timer(stun_time), "timeout")
	
	if died:
		emit_signal("died")
		queue_free()
	
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
	take_damage(10)
	
	$Tween.interpolate_property(self, "knockback_movement", 
								direction.normalized() * force, Vector2(),
								0.4,Tween.TRANS_QUAD, Tween.EASE_OUT)
	$Tween.start()							
	
func change_cam_limit(pos):
	$Camera.limit_left = pos
	
	
	
	
	
	
	
	
	
