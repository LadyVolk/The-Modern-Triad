extends Node2D


func _ready():
	pass


func _process(dt):
	#move walls with player
	$Walls/NorthWall.position.x = $Player.position.x
	$Walls/SouthWall.position.x = $Player.position.x
	
	#move floor
	for tile in $Floors.get_children():
		if tile.rect_position.x - $Player.position.x < -1000:
			tile.rect_position.x += 1920
		elif tile.rect_position.x - $Player.position.x > 1000:
			tile.rect_position.x -= 1920
		
