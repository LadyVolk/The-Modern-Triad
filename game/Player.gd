extends KinematicBody2D

export var speed: int

export var dash_strength = 18000

export var max_speed = 600

var dash_movement = Vector2()

var movement = Vector2()

var dash_time = 0.2

func _ready():
	$Label.text = "life is great"
	$TextureRect.rect_pivot_offset = $TextureRect.rect_size/2
	


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

	if mov_vector != Vector2.ZERO:
		
		apply_movement(mov_vector * speed * delta)
	else:
		apply_friction(speed * delta)
			
	movement = move_and_slide(movement + dash_movement*delta)
	move_and_slide(dash_movement*delta)
	
	$TextureRect.rect_rotation = rad2deg(get_player_direction().angle())+90

func _input(event):
	if event.is_action_pressed("player_dash"):
		dash()


func get_player_direction():
	
	var mouse_pos = get_viewport().get_mouse_position()
	var center_player = $TextureRect.rect_size/2 + global_position
	
	return  (mouse_pos - center_player).normalized()
	
	
func dash():
	if not $DashCooldown.is_stopped():
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
		
