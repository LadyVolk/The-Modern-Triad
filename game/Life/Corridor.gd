extends Node2D

const PAST_DISTANCE = 450

func _ready():
	$Walls/PastWall.position.x = $Player.position.x - PAST_DISTANCE 
		
	$Player.change_cam_limit($Walls/PastWall.position.x)

# warning-ignore:return_value_discarded
	$Mirror.connect("entered_mirror", self, "mirror_enter")

# warning-ignore:unused_argument
func _process(_dt):
	#move walls with player
	$Walls/NorthWall.position.x = $Player.position.x
	$Walls/SouthWall.position.x = $Player.position.x
	
	#move floor
	for tile in $Floors.get_children():
		if tile.rect_position.x - $Player.position.x < -1000:
			tile.rect_position.x += 1920
		elif tile.rect_position.x - $Player.position.x > 1000:
			tile.rect_position.x -= 1920
	if $Mirror.position.x - $Player.position.x < -1000:
		$Mirror.position.x += 1920
	elif $Mirror.position.x - $Player.position.x > 1000:
		$Mirror.position.x -= 1920

	#move past
	var past = $Walls/PastWall.position.x - $Player.position.x
	if past < -PAST_DISTANCE:
		$Walls/PastWall.position.x = $Player.position.x - PAST_DISTANCE 
		
	$Player.change_cam_limit($Walls/PastWall.position.x)


func mirror_enter():
	$Player.disable = true
	$Tween.interpolate_property($ShaderLayer/Fade.get_material(), "shader_param/amount", 
								0.0, 1.0, 1.0, Tween.TRANS_QUAD, Tween.EASE_IN)
	$Tween.start()
	yield($Tween, "tween_completed")
	
	Global.change_scene(2, "res://Bosses/Depression/Level.tscn")
	
