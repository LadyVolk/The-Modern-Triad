extends Node2D


const PROJECTILE = preload("res://PlayerStuff/Projectile.tscn")
const MEDITATION = preload("res://Bosses/Anxiety/Meditation.tscn")

onready var player = $Player
onready var boss = $Anxiety

var can_shoot = false
var times_moved = 0

enum REGION {left, right}

func _ready():
	player.connect("shoot", self, "player_shoot")
	player.connect("update_health", $GameHUD, "update_health")
	player.connect("set_HUD", $GameHUD, "set_HUD")
	player.connect("died", self, "_on_player_died")
	player.connect("stop_boss", boss, "stop_boss")
	player.connect("decrease_boss_speed", boss, "decrease_speed")
	player.connect("increase_boss_speed", boss, "increase_speed")
	boss.connect("new_target_position", self, "get_boss_position")
	boss.connect("anxiety_attack", player, "take_damage")
	boss.connect("change_player_speed", player, "change_speed")
	boss.connect("die", self, "boss_died")
	boss.player = player
	AudioManager.play_bgm("depression")

	$TransitionShader.do_transition()

	$TimerShoot.start()

func player_shoot(pos, direction):
	if can_shoot:
		var new_projectile = PROJECTILE.instance()
		new_projectile.connect("shoot_at_boss", self, "boss_take_damage")
		$Projectiles.add_child(new_projectile)
		new_projectile.position = pos
		new_projectile.direction = direction
		$TimerShoot.start()
		can_shoot = false
		
	
		
func random_position():
	times_moved += 1
	if times_moved >= 4:
		times_moved = 0
		return player.position
	randomize()
	var shape = $BossArea/CollisionShape2D.shape
	var area = $BossArea.position
	var new_pos = Vector2(rand_range(area.x-shape.extents.x, area.x+shape.extents.x), 
						  rand_range(area.y-shape.extents.y, area.y+shape.extents.y))
	return new_pos
	
func get_boss_position(boss_):
	boss_.target_destination = random_position()
	
	
func _on_player_died():
	player = null
	boss.player = null
	
	$FadeScreen.fade_out()
	
	yield($FadeScreen, "fade_out_finished")
	
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Level.tscn")
	
	
func stun_player(stun_time, direction, force):
	if player:
		player.stun(stun_time, direction, force)	


func _on_Timer_timeout():
	can_shoot = true


func create_meditation():
	var new_meditation
	
	randomize() 
	var which_area
	if $Meditations.get_child_count() == 0:
		new_meditation = MEDITATION.instance()
		$Meditations.add_child(new_meditation)
		if randf() >= 0.5:
			which_area = $BoostSpawnAreaL
			new_meditation.region = REGION.left
		else:
			which_area = $BoostSpawnAreaR
			new_meditation.region = REGION.right
	else:
		return
	
	var shape = which_area.get_node("CollisionShape").shape
	
	new_meditation.position.x = rand_range(which_area.position.x-shape.extents.x, 
									which_area.position.x+shape.extents.x)
	new_meditation.position.y = rand_range(which_area.position.y-shape.extents.y, 
									which_area.position.y+shape.extents.y)


func _on_TimerMeditation_timeout():
	create_meditation()


func boss_take_damage():
	boss.take_damage(200)

func boss_died():
	$FadeScreen.fade_out()
	yield($FadeScreen, "fade_out_finished")
	Global.change_scene(0.1, "res://Life/Corridor3.tscn")
	
