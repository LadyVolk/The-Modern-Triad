extends Node2D

export var speed: int

export var dash_strength = 200

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
	position += mov_vector * speed * delta
	
	
	$TextureRect.rect_rotation = rad2deg(get_player_direction().angle())+90

func _input(event):
	if event.is_action_pressed("player_dash"):
		dash()

func get_player_direction():
	
	var mouse_pos = get_local_mouse_position()
	var center_player = $TextureRect.rect_size/2
	
	return  (mouse_pos - center_player).normalized()
	
func dash():
	var direction = get_player_direction()
	
	position += direction * dash_strength
