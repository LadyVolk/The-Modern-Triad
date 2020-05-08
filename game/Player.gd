extends Node2D

export var speed: int

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
	
	var mouse_pos = get_local_mouse_position()
	var center_player = $TextureRect.rect_size/2
	
	var direction = mouse_pos - center_player
	
	$TextureRect.rect_rotation = rad2deg(direction.angle())+90
