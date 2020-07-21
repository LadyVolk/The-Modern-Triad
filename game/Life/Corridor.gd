extends Node2D


func _ready():
	pass


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
