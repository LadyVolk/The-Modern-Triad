extends Node2D

const PROJECTILE = preload("res://Projectile.tscn")
const SPEED_BOOST = preload("res://Bosses/Depression/SpeedBoost.tscn")
const NEGATIVITY = preload("res://Bosses/Depression/Negativity.tscn")
const FAKE_SPEED_BOOST = preload("res://Bosses/Depression/FakeSpeedBoost.tscn")
const DELUSION_BOSS = preload("res://Bosses/Depression/Depression.tscn")

onready var player = $Player
onready var timer = $SpeedBoostTimer
onready var boss = $Depression

var max_delusions = 3

enum REGION {left, right}

func _ready():
	player.connect("shoot", self, "player_shoot")
	player.connect("update_health", $GameHUD, "update_health")
	player.connect("set_HUD", $GameHUD, "set_HUD")
	boss.connect("depression_shoot", self, "boss_shoot")
	boss.connect("new_target_position", self, "get_boss_position")
	boss.connect("create_delusion", self, "create_delusion_boss")
	create_boost()
	create_boost()
	boss.player = player
	

func player_shoot(pos, direction):
	var new_projectile = PROJECTILE.instance()
	$Projectiles.add_child(new_projectile)
	new_projectile.position = pos
	new_projectile.direction = direction
	

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
	

func create_fake_boost():
	var new_boost
	randomize() 
	var which_area
	if $FakeSpeedBoosts.get_child_count() == 0:
		new_boost = FAKE_SPEED_BOOST.instance()
		$FakeSpeedBoosts.add_child(new_boost)
		if randf() >= 0.5:
			which_area = $BoostSpawnAreaL
			new_boost.region = REGION.left
		else:
			which_area = $BoostSpawnAreaR
			new_boost.region = REGION.right
			
	elif $FakeSpeedBoosts.get_child_count() == 1:
		new_boost = FAKE_SPEED_BOOST.instance()
		$FakeSpeedBoosts.add_child(new_boost)
		if $FakeSpeedBoosts.get_child(0).region == REGION.left:
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


func boss_shoot(pos, direction):
	var new_projectile = NEGATIVITY.instance()
	$Projectiles.add_child(new_projectile)
	new_projectile.position = pos
	new_projectile.direction = direction
	
	new_projectile.connect("stun_player", player, "stun")
	
	
func random_position():
	randomize()
	var shape = $BossArea/CollisionShape2D.shape
	var area = $BossArea.position
	var new_pos = Vector2(rand_range(area.x-shape.extents.x, area.x+shape.extents.x), 
						  rand_range(area.y-shape.extents.y, area.y+shape.extents.y))
	return new_pos
	
func get_boss_position(boss_):
	boss_.target_destination = random_position()


func _on_SpeedBoostTimer_timeout():
	if boss.boss_state == 3:
		create_boost()
		create_fake_boost()
	else:
		create_boost()
	
	
func create_delusion_boss(position):
	if $Delusions.get_child_count() >= max_delusions:
		return
	
	var boss_instance = DELUSION_BOSS.instance()
	
	$Delusions.add_child(boss_instance)
	boss_instance.position = position
	boss_instance.health = 1
	boss_instance.is_delusion = true	
	boss_instance.connect("depression_shoot", self, "boss_shoot")
	boss_instance.connect("new_target_position", self, "get_boss_position")
	boss_instance.player = player
	boss_instance.boss_state = 3
	
	
	
