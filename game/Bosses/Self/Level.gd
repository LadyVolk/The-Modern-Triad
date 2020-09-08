extends Node2D


const PROJECTILE = preload("res://PlayerStuff/Projectile.tscn")
const SITUATION = preload("res://Bosses/Self/Situation.tscn")

onready var player = $Player
onready var self_boss = $Self

var can_shoot = false
var times_moved = 0
var number_shoots = 10

enum REGION {left, right}

func _ready():
	player.connect("shoot", self, "player_shoot")
	player.connect("update_health", $GameHUD, "update_health")
	player.connect("set_HUD", $GameHUD, "set_HUD")
	player.connect("died", self, "_on_player_died")
	
	
	self_boss.player = player
	
	AudioManager.play_bgm("depression")

	Global.freeze = true
	
	$Tween.interpolate_property($Shaders/FadeIn.get_material(), "shader_param/amount", 
								1.0, 0.0, 1.0, Tween.TRANS_QUAD, Tween.EASE_IN)
	$Tween.start()
	
	yield($Tween, "tween_completed")
	
	$Shaders/Pixel/AnimationPlayer.play("PixelEffect")

	$TimerShoot.start()

func player_shoot(pos, direction):
	if can_shoot:
		var new_projectile = PROJECTILE.instance()
		new_projectile.connect("shoot_at_projectile", self, "die_projectile")
		$Projectiles.add_child(new_projectile)
		new_projectile.position = pos
		new_projectile.direction = direction
		$TimerShoot.start()
		
		var new_projectile_inverted = PROJECTILE.instance()
		$Projectiles.add_child(new_projectile_inverted)
		new_projectile_inverted.position = self_boss.position
		new_projectile_inverted.direction = -direction
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
	
	
func _on_player_died():
	player = null
	
	$FadeScreen.fade_out()
	
	yield($FadeScreen, "fade_out_finished")
	
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Level.tscn")
	
	
func player_damage():
	if player:
		player.take_damage(25)	


func _on_AnimationPlayer_animation_finished(_anim_name):
	Global.freeze = false


func _on_Timer_timeout():
	can_shoot = true


func die_projectile(projectile1, projectile2):
	projectile1.queue_free()
	projectile2.queue_free()



func _on_Situations_timeout():
	randomize()
	
	var missing_shoot = randi()%number_shoots+1
	var position
	var direction
	var situation_size = 64
	var space_between = 80
	var margin = -20
	var space_spawn = space_between*((number_shoots/2)-1) \
					 + situation_size/2
	
	if rand_range(0, 1) < 0.5:
		position = Vector2(rand_range(0, get_viewport().size.x - space_spawn), margin)
		direction = Vector2(0, 1)
		
		for i in range(1, number_shoots + 1):
			if i == missing_shoot:
				continue

			if i % 2:
				boss_shoot(position, direction)
			else:
				boss_shoot(Vector2(get_viewport().size.x - position.x, 
								   get_viewport().size.y - margin), -direction)
				position.x = position.x + space_between
	else:
		position = Vector2(margin, rand_range(0, get_viewport().size.y - space_spawn))
		direction = Vector2(1, 0)
		
		for i in range(1, number_shoots + 1):
			if i == missing_shoot:
				continue
			if i % 2:
				boss_shoot(position, direction)
			else:
				boss_shoot(Vector2(get_viewport().size.x - margin, 
								   get_viewport().size.y - position.y), -direction)
				position.y = position.y + space_between
	
	
func boss_shoot(position, direction):
	var new_situation = SITUATION.instance()
	
	$Projectiles.add_child(new_situation)
	new_situation.position = position
	new_situation.direction = direction
	
	new_situation.connect("situation_damage", self, "player_damage")
	
