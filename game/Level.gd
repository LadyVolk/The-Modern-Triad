extends Node2D

const PROJECTILE = preload("res://Projectile.tscn")
const SPEED_BOOST = preload("res://Bosses/Depression/SpeedBoost.tscn")

onready var player = $Player
onready var timer = $SpeedBoostTimer

enum REGION {left, right}


func _ready():
	player.connect("shoot", self, "player_shoot")
	player.connect("update_health", $GameHUD, "update_health")
	player.connect("set_HUD", $GameHUD, "set_HUD")

func player_shoot(pos, direction):
	var new_projectile = PROJECTILE.instance()
	$Projectiles.add_child(new_projectile)
	new_projectile.position = pos
	new_projectile.direction = direction

func _input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_SPACE:
			player.take_damage(30)

func create_boost():
	
	var new_boost
	
	
	randomize() 
	var which_area
	if $SpeedBoosts.get_child_count() == 0:
		new_boost = SPEED_BOOST.instance()
		$SpeedBoosts.add_child(new_boost)
		if randf() >= 0.5:
			which_area = $BoostSpawnAreaL
			new_boost.region = REGION.left
		else:
			which_area = $BoostSpawnAreaR
			new_boost.region = REGION.right
			
	elif $SpeedBoosts.get_child_count() == 1:
		new_boost = SPEED_BOOST.instance()
		$SpeedBoosts.add_child(new_boost)
		if $SpeedBoosts.get_child(0).region == REGION.left:
			which_area = $BoostSpawnAreaR
			new_boost.region = REGION.right
		else:
			which_area = $BoostSpawnAreaL
			new_boost.region = REGION.left
	else:
		return
	
	var shape = which_area.get_node("CollisionShape").shape
	
	new_boost.position.x = rand_range(which_area.position.x-shape.extents.x, 
									which_area.position.x+shape.extents.x)
	new_boost.position.y = rand_range(which_area.position.y-shape.extents.y, 
									which_area.position.y+shape.extents.y)
	

	
